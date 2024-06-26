from django.shortcuts import render


# Create your views here.
def index(request):
    return render(request, "home.html")


def profile(request):
    return render(request, "profile.html")


def navbar(request):
    return render(request, "navbar.html")
