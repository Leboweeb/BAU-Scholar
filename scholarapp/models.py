from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.utils.translation import gettext_lazy as _
from django.utils.timezone import now

# Create your models here.


class CustomUserManager(BaseUserManager):

    def create_user(self, email, password, **extra_fields):
        if not email:
            raise ValueError(_("The Email must be set"))
        email = self.normalize_email(email)  # lowercase the domain
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password, **extra_fields):
        """
        Create and save a superuser with the given email,
        password, and date_of_birth. Extra fields are added
        to indicate that the user is staff, active, and indeed
        a superuser.
        """
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)
        if extra_fields.get("is_staff") is not True:
            raise ValueError(_("Superuser must have is_staff=True."))
        if extra_fields.get("is_superuser") is not True:
            raise ValueError(_("Superuser must have is_superuser=True."))
        return self.create_user(email, password, **extra_fields)


class CustomUser(AbstractUser):
    username = None
    name = models.CharField(max_length=120)
    email = models.EmailField(_("email address"), unique=True)
    avatar = models.URLField(default="")
    profile_url = models.URLField(default="")
    USERNAME_FIELD = "email"
    objects = CustomUserManager()  # type: ignore
    REQUIRED_FIELDS = ["name"]

    def __str__(self) -> str:
        return self.email


class EventTypes(models.TextChoices):
    CONFERENCE_PAPER = "CN", _("Conference Paper")
    JOURNAL_PAPER = "JN", _("Journal Paper")
    ARTICLE = "AR", _("Article")
    CHAPTER = "CH", _("Chapter")
    PREPRINT = "PP", _("Preprint")
    PRESENTATION = "PR", _("Presentation")
    POSTER = "PO", _("Poster")
    CONFERENCE_EVENT = "CNE", _("Conference Event")
    WORKSHOP = "WR", _("Workshop")
    THESIS_SUPERVISION = "TH", _("Thesis Supervision")


class Event(models.Model):
    title = models.CharField(max_length=350)
    description = models.CharField(max_length=512)
    authors = models.ManyToManyField(CustomUser, blank=True)
    attendees = models.ManyToManyField(CustomUser, blank=True, related_name="attendees")
    author_str = models.CharField(max_length=256)
    external_link = models.URLField(null=True)
    date_created = models.DateTimeField(default=now)
    event_type = models.CharField(max_length=3, choices=EventTypes)
    tags = models.CharField(max_length=256)


class Followers(models.Model):
    follower = models.ForeignKey(
        CustomUser, related_name="from_user", on_delete=models.CASCADE
    )
    following = models.ForeignKey(
        CustomUser, related_name="to_users", on_delete=models.CASCADE
    )


class Conversation(models.Model):
    users = models.ManyToManyField(CustomUser)
    title = models.CharField(max_length=120, null=True)
    description = models.CharField(max_length=512, null=True)
    room_slug = models.SlugField(max_length=240, unique=True, null=False)
    group_icon = models.TextField(
        default="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' height='48px' viewBox='0 -960 960 960' width='48px' fill='%23000000'%3E%3Cpath d='M38-160v-94q0-35 18-63.5t50-42.5q73-32 131.5-46T358-420q62 0 120 14t131 46q32 14 50.5 42.5T678-254v94H38Zm700 0v-94q0-63-32-103.5T622-423q69 8 130 23.5t99 35.5q33 19 52 47t19 63v94H738ZM358-481q-66 0-108-42t-42-108q0-66 42-108t108-42q66 0 108 42t42 108q0 66-42 108t-108 42Zm360-150q0 66-42 108t-108 42q-11 0-24.5-1.5T519-488q24-25 36.5-61.5T568-631q0-45-12.5-79.5T519-774q11-3 24.5-5t24.5-2q66 0 108 42t42 108ZM98-220h520v-34q0-16-9.5-31T585-306q-72-32-121-43t-106-11q-57 0-106.5 11T130-306q-14 6-23 21t-9 31v34Zm260-321q39 0 64.5-25.5T448-631q0-39-25.5-64.5T358-721q-39 0-64.5 25.5T268-631q0 39 25.5 64.5T358-541Zm0 321Zm0-411Z'/%3E%3C/svg%3E"
    )


class Message(models.Model):
    parent_conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    user_from = models.ForeignKey(
        CustomUser, on_delete=models.CASCADE, related_name="user_from"
    )
    message = models.TextField(null=True)
    time_sent = models.DateTimeField(auto_now_add=True)


class Profile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    rank = models.CharField(max_length=256, default="")
    department = models.CharField(max_length=256, default="")
    program = models.CharField(max_length=256, default="")
    research_interests = models.CharField(max_length=256, default="")
    rank_link = models.URLField()
    tags = models.CharField(max_length=256, default="")
    skills = models.CharField(max_length=256, default="")
    education = models.TextField(default="")
    academic_experience = models.TextField(default="")
    non_academic_experience = models.TextField(default="")
    certifications = models.TextField(default="")
    memberships = models.TextField(default="")
    honors = models.TextField(default="")
    service_activities = models.TextField(default="")
    courses = models.TextField(default="")
    references = models.TextField(default="")
    development_activities = models.TextField(default="")
    staff_member_achievements = models.TextField(default="")
