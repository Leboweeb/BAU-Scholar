from django.contrib.auth.forms import UserCreationForm
from django import forms
from scholarapp.models import CustomUser


class SignUpForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = (
            "name",
            "email",
        )

        widgets = {
            "avatar": forms.HiddenInput(),
            "profile_url": forms.HiddenInput(),
            "skills": forms.HiddenInput(),
        }
