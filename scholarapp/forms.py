from django.contrib.auth.forms import UserCreationForm
from django import forms
from scholarapp.models import CustomUser, Event
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Column, HTML
from crispy_bootstrap5.bootstrap5 import Switch


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

    participated = forms.BooleanField(widget=forms.CheckboxInput())

    class Meta:
        model = Event
        fields = ("title", "description", "event_type", "authors")

    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.layout = Layout(
            "title",
            "description",
            "event_type",
            Column(
                HTML(
                    """
                <label class="form-label requiredField" for="authors">Authors</label>
                <input hx-post="/get_authors"  hx-trigger="input changed delay:500ms, search" hx-target="#author_container" hx-swap="innerHTML" type="search" name="author_search" id="author_search" class="form-control" placeholder="Search People">
                """
                ),
                css_class="mb-3",
            ),
            Column(Switch("participated", wrapper_class="form-check form-switch")),
        )
