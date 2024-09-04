from typing import Any, Mapping
from django.contrib.auth.forms import UserCreationForm
from django import forms
from django.forms.renderers import BaseRenderer
from django.forms.utils import ErrorList
from scholarapp.models import CustomUser, Publication
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Submit, Row, Column


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


class PostSignUpForm(forms.Form):
    department = forms.CharField()
    program = forms.CharField()
    research_interests = forms.CharField(label="Research Interests")
    rank = forms.CharField()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.layout = Layout(
            "department",
            "program",
            Column("research_interests", css_class="col", required=None),
            "rank",
            # Row(
            #     Column("department", css_class="col"),
            #     Column("program", css_class="col"),
            #     css_class="row",
            # ),
            # Row(
            #     Column("research_interests", css_class="col"),
            #     Column("rank", css_class="col"),
            #     css_class="row",
            # ),
        )
