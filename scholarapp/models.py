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


class Followers(models.Model):
    follower = models.ForeignKey(
        CustomUser, related_name="from_user", on_delete=models.CASCADE
    )
    following = models.ForeignKey(
        CustomUser, related_name="to_users", on_delete=models.CASCADE
    )


class Conversation(models.Model):
    users = models.ManyToManyField(CustomUser)
    title = models.CharField(max_length=120)
    description = models.CharField(max_length=512)
    room_slug = models.SlugField(max_length=240, unique=True, null=False)


class Message(models.Model):
    parent_conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    user_from = models.ForeignKey(
        CustomUser, on_delete=models.CASCADE, related_name="user_from"
    )
    user_to = models.ForeignKey(
        CustomUser, on_delete=models.CASCADE, related_name="user_to"
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
