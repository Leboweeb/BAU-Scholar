from django.urls import path
from django.contrib.auth.views import (
    LogoutView,
    PasswordResetDoneView,
    PasswordResetConfirmView,
    PasswordResetCompleteView,
)
from . import views
from .views import GenerateFacultyReportView


urlpatterns = [
    path("", views.index, name="index"),
    path("profile/<user_id>", views.profile, name="profile"),
    path("login/", views.LoginView.as_view(), name="login"),
    path("logout", LogoutView.as_view(), name="logout"),
    path(
        "password_reset/",
        views.CustomResetPasswordView.as_view(),
        name="password_reset",
    ),
    path(
        "password_reset/done/",
        PasswordResetDoneView.as_view(
            template_name="registration/password_reset_done.html"
        ),
        name="password_reset_done",
    ),
    path(
        "password_reset/confirm/<uidb64>/<token>/",
        PasswordResetConfirmView.as_view(
            template_name="registration/password_reset_auth.html"
        ),
        name="password_reset_confirm",
    ),
    path(
        "password_reset/confirm/complete/",
        PasswordResetCompleteView.as_view(
            template_name="registration/password_reset_auth_complete.html"
        ),
        name="password_reset_complete",
    ),
    path("signup/", views.sign_in, name="signup"),
    path("import_user", views.import_user, name="import"),
    path(
        "follow_status/<int:to_user_id>/<str:status>",
        views.follow_status,
        name="follow_status",
    ),
    path(
        "create_conversation_room",
        views.create_conversation_room,
        name="create_conversation_room",
    ),
    path("get_groups", views.get_groups, name="get_groups"),
    path("get_chat_history", views.get_chat_history, name="get_chat_history"),
    path("update_profile", views.update_profile, name="update_profile"),
    path("generate_user_cv", views.generate_user_document, name="generate_user_cv"),
    path("generate_report", views.generate_report, name="generate_report"),
    path(
        "participate_in_event", views.participate_in_event, name="participate_in_event"
    ),
    path("get_events", views.get_events, name="get_events"),
    path("dashboard/statistics", views.dashboard, name="statistics"),
    path("dashboard/staff_achievements", views.dashboard, name="staff_achievements"),
    path("search_users", views.search_users, name="search_users"),
    path('generate-faculty-report/', GenerateFacultyReportView.as_view(), name='generate_faculty_report'),
    path(
        "search_tags_for_user", views.search_tags_for_user, name="search_tags_for_user"
    ),
    path("search_tags", views.search_tags, name="search_tags"),
    path("update_event", views.update_event, name="update_event"),
]
