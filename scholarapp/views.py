import base64
from datetime import datetime
from http import HTTPStatus
from io import BytesIO
import json
import os
from dateutil.parser import parse
from django.db.models.query import QuerySet
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib.auth.views import LoginView
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.template.defaulttags import register
from django.utils.text import slugify
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from scholarapp.forms import CreateEventForm, SignUpForm
from scholarapp.models import Conversation, CustomUser, Followers, Profile, Publication
from scholarapp.serializers import ImportUserSerializer
from dotenv import load_dotenv
from scholarapp.utils.generate_cv import generate_cv, generate_staff_achievements
from scholarapp.utils.scrape_user import scrape_author, scrape_publications
from scholarapp.utils.profile_info import create_user_profile

load_dotenv()

current_year = datetime.now().year


# Create your views here.
@register.filter(name="split")
def split(value, key):
    """
    Returns the value turned into a list.
    """
    return value.split(key)


@register.filter(name="as_id")
def as_id(value: str):
    return value.lower().replace(" ", "_")


@login_required
def index(request):
    followed_users = [follow.following for follow in request.user.from_user.all()]
    categories = [
        Publication.objects.order_by("-date_created")[:5],
        Publication.objects.order_by("-date_created")[:5],
        Publication.objects.filter(authors__in=followed_users)[:5],
    ]
    return render(
        request,
        "home.html",
        context={
            "user": request.user,
            "categories": categories,
            "current_year": current_year,
        },
    )


@login_required
def profile(request, user_id: str):
    labels = [
        {"label": "Rank", "required": True, "single": True},
        {"label": "Department", "required": True, "single": True},
        {"label": "Program", "required": True, "single": True},
        {"label": "Research Interests", "required": False, "single": True},
        {"label": "Rank Link", "required": False, "single": True},
        {"label": "Tags", "required": False, "single": False},
        {"label": "Skills", "required": False, "single": False},
        {"label": "Education", "required": False, "single": False},
        {"label": "Academic Experience", "required": False, "single": False},
        {"label": "Non Academic Experience", "required": False, "single": False},
        {"label": "Certifications", "required": False, "single": False},
        {"label": "Organization Membership", "required": False, "single": False},
        {"label": "Honors and Awards", "required": False, "single": False},
        {"label": "Service Activities", "required": False, "single": False},
        {"label": "Experience Courses", "required": False, "single": False},
        {"label": "References", "required": False, "single": False},
        {
            "label": "Professional Development Activities",
            "required": False,
            "single": False,
        },
    ]
    user = CustomUser.objects.get(pk=user_id)
    user_profile: Profile | None = user.profile  # type: ignore
    user_profile_fields = [
        getattr(user_profile, attr.attname).split("•")  # type: ignore
        for attr in Profile._meta.get_fields()[2:-1]
    ]
    is_current_user = request.user == user
    is_following_user = request.user.from_user.filter(following_id=user.pk).exists()
    # process tags first
    # if user_profile:
    #     if not user_profile.tags:
    #         gemini_model = genai.GenerativeModel("gemini-1.5-flash")
    #         user_profile.tags = gemini_model.generate_content(
    #             f"Given these skills : {user_profile.skills} \n Generate tags that are as inclusive and brief as possible ( use only alphabetic characters and spaces for each tag) and as a comma separated string."
    #         ).text
    #         user_profile.tags = re.sub("\n", "", user_profile.tags).strip()
    #         user_profile.save()
    # then publications
    user_publications = Publication.objects.filter(authors=user)
    if not user_publications.exists():
        scraped_publications = scrape_publications(user.profile_url)
        publication_pairs = [
            Publication.objects.get_or_create(
                title=publication["title"],
                description=publication["description"],
                author_str=publication["authors"],
                date_created=parse(publication["date_created"]),
            )
            for publication in scraped_publications
        ]
        for publication, _ in publication_pairs:
            publication.authors.add(user)
    context = {
        "user": user,
        "publications": user_publications.all(),
        "is_current_user": is_current_user,
        "is_following": is_following_user,
        "form": CreateEventForm(),
        "records": zip(labels, user_profile_fields),
        "current_year": current_year,
    }
    # if request.method == "POST":
    #     Profile.objects.update_or_create(
    #         defaults=create_user_profile(
    #             request.POST, [l["label"] for l in labels], request.user.pk
    #         )
    #     )
    return render(request, "profile.html", context=context)


@login_required
def follow_status(request, to_user_id: int, status: str):
    to_user = get_object_or_404(CustomUser, id=to_user_id)
    if status == "follow":
        if not request.user.from_user.filter(following_id=to_user_id).exists():
            Followers.objects.create(follower=request.user, following=to_user)
    elif status == "unfollow":
        request.user.from_user.filter(following_id=to_user_id).delete()
    return redirect("profile", user_id=to_user_id)


@api_view(["POST"])
def get_chat_history(request):
    slug = request.data["conversation_slug"]
    conversation = Conversation.objects.get(room_slug=slug)
    messages: QuerySet = conversation.message_set.all()  # type: ignore
    return render(
        request,
        "components/message_history.html",
        context={"messages": messages, "user_id": request.user.pk},
    )


@api_view(["POST"])
def generate_user_document(request):
    # try:
    document_generator = [
        generate_cv,
        generate_staff_achievements,
    ][int(request.data["selected_document"])]
    user = CustomUser.objects.get(pk=int(request.data["user_id"]))
    user_publications = [
        (f"{publication.author_str} : {publication.title}\n\n")
        for publication in Publication.objects.filter(authors=user)
    ]
    buffer = BytesIO()
    # docx is saved to buffer now
    document_generator(request.user, user_publications, buffer)
    b64_data = base64.b64encode(buffer.getvalue())
    return JsonResponse({"data": b64_data.decode()})
    # except CustomUser.DoesNotExist:
    #     return HttpResponseForbidden()


def update_profile(request):
    user = CustomUser.objects.get(id=request.user.pk)
    personal_info_labels = list(request.POST.keys())[1:]
    Profile.objects.update_or_create(
        defaults=create_user_profile(
            request.POST, personal_info_labels, request.user.pk
        )
    )
    # fetch user profile after update
    user_profile = user.profile  # type: ignore
    response = render(
        request,
        "components/profile/profile_tags_skills_fragment.html",
        context={"user_profile": user_profile, "is_current_user": True},
    )
    return response


@api_view(["POST"])
def get_contacts(request):
    user = CustomUser.objects.get(pk=int(request.data["user_id"]))
    query = Conversation.objects.filter(users=user)[:5]
    contacts = [
        conversation.users.all().exclude(id=user.pk)[0] for conversation in query
    ]
    conversations = [c.room_slug for c in query]
    contacts = zip(contacts, conversations)
    return render(
        request,
        "components/contacts.html",
        context={
            "contacts": contacts,
        },
    )


@api_view(["POST"])
def create_conversation_room(request):
    user_ids = [int(_id) for _id in request.data["user_ids"]]
    conversation = Conversation.objects.create()
    for user in [CustomUser.objects.get(id=_id) for _id in user_ids]:
        conversation.users.add(user)
    conversation.room_slug = slugify(
        "_".join(user.name for user in conversation.users.all())
    )
    conversation.save()
    return Response({"conversation_room": conversation.room_slug})


@api_view(["POST"])
def import_user(request):
    serializer = ImportUserSerializer(data=request.data)
    if request.method == "POST":
        if serializer.is_valid():
            name = serializer.validated_data["name"]  # type: ignore
            if name in list(
                map(
                    lambda file: file.replace(".json", ""),
                    os.listdir("./scholarapp/cached"),
                )
            ):
                with open(f"./scholarapp/cached/{name}.json") as f:
                    return Response(json.load(f))
            scraped_profiles = scrape_author(name)
            return Response({"profiles": scraped_profiles})
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def sign_in(request):
    if request.method == "POST":
        form = SignUpForm(request.POST)
        if form.is_valid():
            model = form.save(commit=False)
            attrs = ("avatar", "profile_url", "skills")
            for attr in attrs:
                setattr(model, attr, request.POST.get(attr))
            model.save()
            return redirect("/")
        return render(request, "registration/signup.html", context={"form": form})
    else:
        form = SignUpForm()
        request.session["next"] = request.GET.get("next", "/")
        return render(
            request,
            "registration/signup.html",
            context={"form": form},
        )


class MyLoginView(LoginView):
    redirect_authenticated_user = True

    def get_success_url(self):
        return reverse_lazy("/")

    def form_invalid(self, form):
        messages.error(self.request, "Invalid username or password")
        return self.render_to_response(self.get_context_data(form=form))
