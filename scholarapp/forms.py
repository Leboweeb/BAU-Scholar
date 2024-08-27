from django.contrib.auth.forms import UserCreationForm
from django import forms
from scholarapp.models import CustomUser, Publication


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


class CreateEventForm(forms.ModelForm):

    class Meta:
        model = Publication
        fields = ("title", "description")
        authors = forms.TextInput()
