from django.http import JsonResponse
from django.shortcuts import redirect, render
from django.contrib.auth.views import LoginView
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from scholarapp.forms import SignUpForm
from scholarapp.serializers import ImportUserSerializer
from scholarapp.utils.scrape_user import scrape_author


# Create your views here.
@login_required
def index(request):
    return render(request, "home.html")


def profile(request):
    return render(request, "profile.html")


def navbar(request):
    return render(request, "navbar.html")


@api_view(["POST"])
def import_user(request):
    if request.method == "POST":
        serializer = ImportUserSerializer(data=request.data)
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
