from django.contrib.auth.forms import UserCreationForm
from django import forms
from django.forms import Textarea
from django.template.loader import render_to_string
from scholarapp.models import CustomUser, Event, EventTypes
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Column, HTML
from crispy_bootstrap5.bootstrap5 import Switch

from scholarapp.utils.common import as_id


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
        }


class CreateEventForm(forms.ModelForm):

    class Meta:
        model = Event
        fields = ("title", "description", "event_type")
        widgets = {"description": Textarea()}

    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.layout = Layout(
            "title",
            "description",
            "event_type",
            Column(
                HTML(
                    render_to_string(
                        "components/dynamic_autocomplete_input.html",
                        context={
                            "autocomplete": True,
                            "single": True,
                            "endpoint": "/search_tags_for_user",
                            "top_label": "Event Tags",
                            "element_id": as_id("Event Tags"),
                            "top": "40px",
                        },
                    )
                ),
                css_class="mb-3",
            ),
            Column(
                HTML(
                    render_to_string(
                        "components/dynamic_autocomplete_input.html",
                        context={
                            "autocomplete": True,
                            "single": True,
                            "endpoint": "/search_users",
                            "top_label": "Authors",
                            "element_id": as_id("Authors"),
                            "top": "40px",
                        },
                    )
                ),
                css_class="mb-3",
            ),
        )
