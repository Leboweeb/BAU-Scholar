import base64
from datetime import datetime
from http import HTTPStatus
from io import BytesIO
import json
import os
import re
from dateutil.parser import parse
from django.http import JsonResponse
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
from scholarapp.models import (
    Conversation,
    CustomUser,
    EventTypes,
    Followers,
    Profile,
    Event,
)
from scholarapp.serializers import ImportUserSerializer
from dotenv import load_dotenv
from scholarapp.utils.common import (
    create_event_dicts,
    exclude_keys,
    get_home_feed,
    get_user_events,
    get_user_research,
    join_with_dot,
    return_with_no_content,
    zip_if_equal,
)
from scholarapp.utils.document_utils import (
    cv_json_to_cv_profile,
    generate_cv,
    generate_document_json,
    generate_form_fields,
    generate_staff_achievements,
)
from scholarapp.utils.scrape_user import scrape_author, scrape_publications
from scholarapp.utils.profile_info import create_user_profile
from scholarapp.utils.tags import (
    get_faculties,
    get_programs_for_departments,
    get_tags_for_program,
)

load_dotenv()

current_year = datetime.now().year
staff_achievement_labels = [
    "Contribute effectively to developing the faculty’s curriculum at both program and departmental levels",
    "Use a variety of advanced innovative learning methods- effective teaching",
    "Use of students self learning methods in teaching",
    "Support students effectively through academic advising and office hours.",
    "Teaching load ( weekly )",
    "Quality Assurance Activities ( courses specification ,course report, ….     )",
    "Contribute to students’ activities and communicate with them scientifically and academically",
    "Others ( First Section )",
    "Others ( Second Section )",
    "Participation in different committees ( faculty - university )",
    "Participation in community and cultural activities",
    "Participation in conferences and workshops organization",
    "Other services to the Lebanese society",
    "Training and consultation",
    "Others ( Third Section )",
]

cv_labels = [
    {"label": "Rank", "required": True, "single": True},
    {
        "label": "Department",
        "required": True,
        "single": True,
        "select": True,
        "choices": get_faculties(),
    },
    {"label": "Program", "required": True, "single": True, "select": True},
    {"label": "Research Interests", "required": False, "single": True},
    {"label": "Rank Link", "required": False, "single": True},
    {
        "label": "Tags",
        "required": False,
        "single": True,
        "autocomplete": True,
        "endpoint": "/search_tags",
        "top": "42px",
    },
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


events_with_participants = [
    EventTypes.WORKSHOP,
    EventTypes.CONFERENCE_EVENT,
    EventTypes.THESIS_SUPERVISION,
]


# Create your views here.
@register.filter(name="split")
def split(value: str, key):
    """
    Returns the value turned into a list.
    """
    return value.split(key)


@register.filter(name="can_participate")
def can_participate_in_event(value: EventTypes):
    if value in events_with_participants:
        return True
    return False


@register.filter(name="user_has_participated")
def has_participated(user: CustomUser, event_id: int):
    return Event.objects.filter(id=event_id, attendees=user)


@register.filter(name="as_id")
def as_id(value: str):
    pattern = re.compile(r"[\W+_]")
    return pattern.sub("", value.lower())


def test(request):
    return render(request, "test.html")


@login_required
def index(request):
    categories = get_home_feed(request.user)
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
    user = CustomUser.objects.get(pk=user_id)
    is_current_user = request.user == user
    is_following_user = request.user.from_user.filter(following_id=user.pk).exists()
    user_publications = Event.objects.filter(authors=user).exclude(
        event_type__in=events_with_participants
    )
    user_events = Event.objects.filter(event_type__in=events_with_participants)
    if not user_publications.exists():
        scraped_publications = scrape_publications(user.profile_url)
        event_types = {choice.label: choice for choice in EventTypes}
        publication_pairs = [
            Event.objects.get_or_create(
                title=publication["title"],
                description=publication["description"],
                author_str=publication["authors"],
                date_created=parse(publication["date_created"]),
                event_type=event_types[publication["research_type"]],
            )
            for publication in scraped_publications
        ]
        for publication, _ in publication_pairs:
            publication.authors.add(user)

    user_profile_fields, staff_achievement_values = generate_form_fields(user_id)
    context = {
        "user": user,
        "publications": user_publications.all(),
        "user_events": user_events.all(),
        "is_current_user": is_current_user,
        "is_following": is_following_user,
        "form": CreateEventForm(),
        "cv_records": zip_if_equal(cv_labels, user_profile_fields),
        "staff_achievement_records": zip_if_equal(
            staff_achievement_labels,
            staff_achievement_values,
        ),
        "current_year": current_year,
        "options": CustomUser.objects.all(),
    }
    if request.method == "POST":
        eventForm = CreateEventForm(request.POST)
        if eventForm.is_valid():
            event_keys = exclude_keys(eventForm.cleaned_data, "authors")
            event = Event.objects.create(**event_keys)
            authors = request.POST.get("authors_field")
            if not authors:
                # the event creator is assumed to be the author
                # in case someone tries to be funny
                event.authors.add(request.user)
            else:
                # javascript validation saved us, we don't have any shennanigans
                for author_id in map(int, authors.split(",")):
                    event.authors.add(CustomUser.objects.get(id=author_id))
            event.save()
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
    return render(
        request,
        "components/message_history.html",
        context={"messages": conversation.message_set.all(), "user_id": request.user.pk},  # type: ignore
    )


@api_view(["POST"])
def generate_user_document(request):
    document_generator = [
        generate_cv,
        generate_staff_achievements,
    ][int(request.data["selected_document"])]
    user = CustomUser.objects.get(pk=int(request.data["user_id"]))
    user_publications = [
        (f"{publication.author_str} : {publication.title}\n\n")
        for publication in Event.objects.filter(authors=user).exclude(
            event_type__in=(
                EventTypes.WORKSHOP,
                EventTypes.CONFERENCE_EVENT,
                EventTypes.THESIS_SUPERVISION,
            ),
        )
    ]
    buffer = BytesIO()
    # docx is saved to buffer now
    document_generator(request.user, user_publications, buffer)
    b64_data = base64.b64encode(buffer.getvalue())
    return JsonResponse({"data": b64_data.decode()})


@api_view(["POST"])
def participate_in_event(request):
    event_id = request.data["event_id"]
    _has_participated = request.data["has_participated"]
    user = CustomUser.objects.get(pk=request.user.pk)
    event = Event.objects.get(pk=event_id)
    if not _has_participated:
        event.attendees.add(user)
    else:
        event.attendees.remove(user)
    # Same as 200, but client doesn't expect HTML or JSON as response.
    return return_with_no_content()


def update_profile(request):
    user = CustomUser.objects.get(id=request.user.pk)
    if request.POST:
        personal_info_labels = list(request.POST.keys())[1:]
        Profile.objects.update_or_create(
            defaults=create_user_profile(
                request.POST, personal_info_labels, request.user.pk
            )
        )
        response = render(
            request,
            "components/profile/profile_tags_skills_fragment.html",
            context={"user_profile": user.profile, "is_current_user": True},  # type: ignore
        )
        response["HX-Retarget"] = "#tags-skills-fragment"
        return response
    elif request.FILES:
        file = request.FILES.get("imported_document")
        file_name = file.name.lower()
        if file_name.find("achievements") > -1:
            cv_json = generate_document_json(
                [
                    "Contribute effectively to developing the faculty’s curriculum at both program and departmental levels",
                    "Use a variety of advanced innovative learning methods- effective teaching",
                    "Use of students self learning methods in teaching",
                    "Support students effectively through academic advising and office hours.",
                    "Teaching load ( weekly )",
                    "Quality Assurance Activities ( courses specification ,course report, ….     )",
                    "Contribute to students’ activities and communicate with them scientifically and academically",
                    "Others ( First Section )",
                    "Scientific publication",
                    "Conferences",
                    "Workshops",
                    "Supervision of theses",
                    "Others ( Second Section )",
                    "Participation in different committees ( faculty - university )",
                    "Participation in community and cultural activities",
                    "Participation in conferences and workshops organization",
                    "Other services to the Lebanese society",
                    "Training and consultation",
                    "Others ( Third Section )",
                ],
                file,
                [
                    "Scientific publication",
                    "Conferences",
                    "Workshops",
                    "Supervision of theses",
                ],
            )
            generated_profile = {
                "staff_member_achievements": join_with_dot(
                    [cv_json[key][0] for key in cv_json]
                )
            }
        else:
            cv_json = generate_document_json(
                [
                    "Name and Academic rank:",
                    "Education: Degrees, discipline, institution, and date:",
                    "Academic experience",
                    "Non-academic experience",
                    "Certification or professional Registration",
                    "Current membership in professional organizations",
                    "Honors and Awards:",
                    "Service activities",
                    "Experience Courses (Graduate and Undergraduate)",
                    "Research	Interests",
                    "References:",
                    "Rank Link:",
                    "Publications",
                    "Professional development activities in the last years",
                ],
                file,
                ["Publications"],
            )
            generated_profile = cv_json_to_cv_profile(cv_json)

        Profile.objects.update_or_create(
            defaults={**generated_profile, "user_id": request.user.pk}
        )
        # fetch user profile after update
        user_profile_fields, staff_achievement_values = generate_form_fields(
            request.user.pk
        )
        response = render(
            request,
            "update_info.html",
            context={
                "cv_records": zip_if_equal(cv_labels, user_profile_fields),
                "staff_achievement_records": zip_if_equal(
                    staff_achievement_labels, staff_achievement_values
                ),
            },
        )
        return response
    else:
        return return_with_no_content()


@api_view(["POST"])
def get_events(request):
    if query := request.POST.get("event_search"):
        search_method = request.POST.get("search_in") or "title"
        sort_by = request.POST.get("sort_by") or "most_recent"
        sort_by = "-date_created" if sort_by == "most_recent" else "date_created"
        event_objects = Event.objects
        match search_method:

            case "title":
                event_objects = event_objects.filter(title__icontains=query)

            case "people":
                authors = CustomUser.objects.filter(name__icontains=query)
                event_objects = event_objects.filter(authors__in=authors)

            case "research":
                event_objects = get_user_research(request.user).filter(
                    title__icontains=query
                )

            case "events":
                event_objects = get_user_events(request.user).filter(
                    title__icontains=query
                )

            case "tags":
                # leave to same as title for now
                event_objects = event_objects.filter(title__icontains=query)

        event_objects = event_objects.order_by(sort_by)

        categories = create_event_dicts(
            event_objects
            # Event.objects.filter(title__icontains=query).order_by(sort_by)
        )
    else:
        categories = get_home_feed(request.user)
    return render(
        request,
        "components/render_events.html",
        context={"categories": categories},
    )


@api_view(["POST"])
def search_tags(request):
    if not (department := request.POST.get("department")) or not (
        program := request.POST.get("program")
    ):
        return return_with_no_content()
    query = request.POST.get("tags") or ""
    if not query:
        tags = []
    else:
        tags = [
            tag
            for tag in get_tags_for_program(department, program)
            if query.lower() in tag.lower()
        ]
    return render(request, "components/search_tags.html", context={"tags": tags})


@api_view(["POST"])
def search_users(request):
    author = request.POST.get("author_search") or ""
    if not author:
        return return_with_no_content()
    authors = CustomUser.objects.filter(name__icontains=author)[:5]
    return render(
        request, "components/search_contacts.html", context={"contacts": authors}
    )


@api_view(["POST"])
def get_contacts(request):
    if request.POST.get("chat_search"):
        name_to_search = request.POST.get("chat_search")
        try:
            user = CustomUser.objects.get(name__icontains=name_to_search)
        except CustomUser.DoesNotExist:
            return return_with_no_content()
        query = Conversation.objects.filter(users=user)
        contacts = [
            conversation.users.all().exclude(id=request.user.pk)[0]
            for conversation in query
        ]
    else:
        user = CustomUser.objects.get(pk=int(request.user.pk))
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
def swap_program(request):

    if department := request.POST.get("department"):
        choices = get_programs_for_departments(department)
    else:
        choices = []

    return render(
        request,
        "components/dynamic_select_input.html",
        context={
            "label": "Program",
            "choices": choices,
        },
    )


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
