from typing import Any
from django import forms

from django.contrib.auth.forms import UserCreationForm

from scholarapp.models import CustomUser


class SignUpForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ("email",)
