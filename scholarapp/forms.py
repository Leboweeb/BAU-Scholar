from django.contrib.auth.forms import UserCreationForm
from django import forms
from scholarapp.models import CustomUser, Event, EventTypes
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
                        <div class="d-table position-relative">
                            <input type="hidden" name="authors_field" id="authors_field" value=""></input>
                            <input hx-post="/search_users"
                                   hx-trigger="input changed delay:500ms, search"
                                   hx-target="#authors_container"
                                   hx-swap="innerHTML"
                                   type="search"
                                   onclick="showDropDown('#customDropdown')"
                                   name="author_search"
                                   id="author_search"
                                   class="form-control"
                                   style="max-width: 215px;"
                                   placeholder="Search People...">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" style="position: relative;left: 195px;bottom: 31px;" onclick="hideDropDown('#customDropdown')" fill="currentColor" class="bi bi-x cursor-pointer" viewBox="0 0 16 16">
                            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
                            </svg>
                            <div class="my-3 row badges" style="display: flex; gap: 0.175rem;margin-left:0.05rem"></div>
                            <div class="card p-2 w-100 d-none"
                                 id="customDropdown"
                                 style="position: absolute;
                                        top: 40px;
                                        left: 0px;
                                        right: 0px;
                                        z-index: 2">
                                <ul id="authors_container" class="list-group list-group-flush scroll h-fit-content">
                                </ul>
                            </div>
                        </div>
                    """
                ),
                css_class="mb-3",
            ),
        )
