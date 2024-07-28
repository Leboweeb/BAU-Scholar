from django.urls import path
from django.contrib.auth.views import LogoutView

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("profile/<user_id>", views.profile, name="profile"),
    path("login/", views.LoginView.as_view(), name="login"),
    path("logout", LogoutView.as_view(), name="logout"),
    path("signup/", views.sign_in, name="signup"),
    path("import_user", views.import_user, name="import"),
]
