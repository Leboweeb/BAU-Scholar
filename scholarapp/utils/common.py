from http import HTTPStatus
import itertools
import os
import re
import smtplib
import ssl
from typing import Iterable
from django.template.defaulttags import register
from django.http import HttpResponse

from scholarapp.models import Conversation, CustomUser, Event


DOT = "•"


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


def send_email_notification(
    sender: CustomUser,
    receiver: CustomUser,
    chat_message: str,
    referenced_group: Conversation,
):
    port = 587  # For starttls
    smtp_server = "smtp.gmail.com"
    sender_email = os.environ.get("GOOGLE_APP_EMAIL")
    receiver_email = "mys239@student.bau.edu.lb"
    password = os.environ.get("GOOGLE_APP_PASSWORD")
    assert sender_email
    assert password
    message = """\
    
    You have received a new message from {}.
    
    {} : {}
    
    Please check this conversation ({}) for more details.
    You were sent this message because you participated in this app's test.
    """.format(
        sender.name,
        sender.name,
        chat_message,
        referenced_group.title if referenced_group.title else sender.name,
    )

    context = ssl.create_default_context()
    with smtplib.SMTP(smtp_server, port) as server:
        server.ehlo()  # Can be omitted
        server.starttls(context=context)
        server.ehlo()  # Can be omitted
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message)
