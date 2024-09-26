from django.urls import path
from django.contrib.auth.views import LogoutView
from django.views.decorators.csrf import csrf_exempt
from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("profile/<user_id>", views.profile, name="profile"),
    path("login/", views.LoginView.as_view(), name="login"),
    path("logout", LogoutView.as_view(), name="logout"),
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
    path("get_contacts", views.get_contacts, name="get_contacts"),
    path("get_chat_history", views.get_chat_history, name="get_chat_history"),
    path("update_profile", views.update_profile, name="update_profile"),
    path("generate_user_cv", views.generate_user_document, name="generate_user_cv"),
    path(
        "participate_in_event", views.participate_in_event, name="participate_in_event"
    ),
    path("get_events", views.get_events, name="get_events"),
    path("test", views.test, name="test"),
    path("search_users", views.search_users, name="search_users"),
    path("search_tags", views.search_tags, name="search_tags"),
    path("swap_program", views.swap_program, name="swap_program"),
]
