from datetime import datetime
import itertools
import os
import pathlib
import re
import smtplib
import ssl
from http import HTTPStatus
from django.db.models import Q
from typing import Iterable
from django.template.defaulttags import register
from django.http import HttpResponse
from background_task import background
from scholarapp.models import CustomUser, Event, EventTypes, Profile
from urllib.request import urlretrieve

DOT = "•"

events_with_participants = [
    EventTypes.WORKSHOP,
    EventTypes.CONFERENCE_EVENT,
    EventTypes.THESIS_SUPERVISION,
]


current_year = datetime.now().year


def join_with_dot(l: list):
    return DOT.join(l)


@register.filter(name="split_at_dot")
def split_at_dot(s: str):
    return s.split(DOT)


def zip_if_equal(labels: list, values: list):
    """
    zips two lists together if they are both of equal length, zips with a list of empty strings otherwise.
    """
    return (
        zip(labels, values)
        if (values and len(values) == len(labels))
        else zip(labels, itertools.repeat("", len(labels)))
    )


def create_event_dicts(events: Iterable[Event], category: str = ""):
    if not events:
        return []
    return [{"event": ev, "category": category} for ev in events]


def return_with_code(code: HTTPStatus):
    return HttpResponse(status=code.value)


def return_with_no_content():
    return return_with_code(HTTPStatus.NO_CONTENT)


def exclude_keys(dictionary: dict, *keys):
    return {k: dictionary[k] for k in dictionary.keys() if k not in keys}


@register.filter(name="as_id")
def as_id(value: str):
    pattern = re.compile(r"[\W+_]")
    return pattern.sub("", value.lower())


@register.filter(name="id_to_src")
def id_to_src(user_id: str):
    user = CustomUser.objects.get(id=user_id)
    return user.avatar


@background(schedule=10)
def send_email_notification(
    sender_name: str,
    receiver: str,
    referenced_group_name: str | None,
):
    port = 587  # For starttls
    smtp_server = "smtp.gmail.com"
    sender_email = os.environ.get("GOOGLE_APP_EMAIL")
    # receiver_email = "mys239@student.bau.edu.lb"
    password = os.environ.get("GOOGLE_APP_PASSWORD")
    assert sender_email
    assert password
    message = """\
    
    You have received new message(s) from {}.
    Please check this conversation ({}) for more details.
    You were sent this message because you participated in this app's test.
    """.format(
        sender_name,
        referenced_group_name if referenced_group_name else sender_name,
    )

    context = ssl.create_default_context()
    with smtplib.SMTP(smtp_server, port) as server:
        server.starttls(context=context)
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver, message)


def save_user_image(url: str, name: str):
    path = pathlib.Path("./BAU_Scholar/media/uploads/").resolve() / f"{name}.jpg"
    urlretrieve(url, str(path))


def filter_above_year(manager, year):
    return manager.filter(date_created__year__gte=year)


def get_department_data(faculty: str, department: str):
    members = [
        p.user
        for p in Profile.objects.filter(
            faculty__icontains=faculty, department__icontains=department
        )
    ]

    return {
        "research": filter_above_year(
            Event.objects.exclude(event_type__in=events_with_participants),
            current_year - 1,
        )
        .filter(authors__in=members)
        .count(),
        "events": filter_above_year(
            Event.objects.filter(
                event_type__in=events_with_participants, authors__in=members
            ),
            current_year - 1,
        ).count(),
        # sorting a dictionary will return the key that has the highest value. Ex: { "foo" : 1, "bar" : 2 }. sorted(dict) = ["bar","foo"] by default.
        # therefore, sorted(dict)[0] is the maximum
        "most_research": sorted(
            {
                member.name: filter_above_year(
                    Event.objects.filter(authors=member), current_year - 1
                ).count()
                for member in members
            }
        )[0],
    }
