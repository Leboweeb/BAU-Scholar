from dateutil.parser import parse
import re
from django.shortcuts import redirect, render
from django.contrib.auth.views import LoginView
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.template.defaulttags import register
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from scholarapp.forms import SignUpForm
from scholarapp.models import CustomUser, Publication
from scholarapp.serializers import ImportUserSerializer
import google.generativeai as genai
from dotenv import load_dotenv

from scholarapp.utils.scrape_user import scrape_author, scrape_publications

load_dotenv()


# Create your views here.
@register.filter(name="split")
def split(value, key):
    """
    Returns the value turned into a list.
    """
    return value.split(key)


@login_required
def index(request):
    categories = [
        Publication.objects.order_by("-date_created")[:5],
        Publication.objects.order_by("-date_created")[:5],
        Publication.objects.order_by("-date_created")[:5],
    ]
    return render(
        request, "home.html", context={"user": request.user, "categories": categories}
    )


@login_required
def profile(request, user_id: str):
    user = CustomUser.objects.get(pk=user_id)
    is_current_user = request.user == user
    # process tags first
    if not user.tags:
        gemini_model = genai.GenerativeModel("gemini-1.5-flash")
        user.tags = gemini_model.generate_content(
            f"Given these skills : {user.skills} \n Generate tags that are as inclusive and brief as possible ( use only alphabetic characters and spaces for each tag) and as a comma separated string."
        ).text
        user.tags = re.sub("\n", "", user.tags).strip()
        user.save()
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
    }
    return render(request, "profile.html", context=context)


@api_view(["POST"])
def import_user(request):
    serializer = ImportUserSerializer(data=request.data)
    if request.method == "POST":
        if serializer.is_valid():
            name = serializer.validated_data["name"]  # type: ignore
            scraped_profiles = scrape_author(name)
            return Response({"profiles": scraped_profiles})
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def sign_in(request):
    if request.method == "POST":
        form = SignUpForm(request.POST)
        if form.is_valid():
            model = form.save(commit=False)
            for attr in ("avatar", "profile_url", "skills"):
                setattr(model, attr, request.POST.get(attr))
            model.save()
            return redirect("/")
        return render(request, "registration/signup.html", context={"form": form})
    else:
        form = SignUpForm()
        return render(request, "registration/signup.html", context={"form": form})


class MyLoginView(LoginView):
    redirect_authenticated_user = True

    def get_success_url(self):
        return reverse_lazy("/")

    def form_invalid(self, form):
        messages.error(self.request, "Invalid username or password")
        return self.render_to_response(self.get_context_data(form=form))
