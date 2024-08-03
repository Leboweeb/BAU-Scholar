from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.utils.translation import gettext_lazy as _

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
    skills = models.CharField(max_length=256, default="")
    tags = models.CharField(max_length=256, default="")
    USERNAME_FIELD = "email"
    objects = CustomUserManager()  # type: ignore
    REQUIRED_FIELDS = ["name"]

    def __str__(self) -> str:
        return self.email


class Publication(models.Model):
    title = models.CharField(max_length=350)
    description = models.CharField(max_length=512)
    authors = models.ManyToManyField(CustomUser, blank=True)
    author_str = models.CharField(max_length=256)
    date_created = models.DateTimeField(null=True)


class Followers(models.Model):
    follower = models.ForeignKey(
        CustomUser, related_name="from_user", on_delete=models.CASCADE
    )
    following = models.ForeignKey(
        CustomUser, related_name="to_users", on_delete=models.CASCADE
    )
