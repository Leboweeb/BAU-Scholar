from http import HTTPStatus
import itertools
from typing import Iterable

from django.http import HttpResponse

from scholarapp.models import CustomUser, Event, EventTypes


DOT = "•"


def join_with_dot(l: list):
    return DOT.join(l)


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


def get_home_feed(user: CustomUser):
    followed_users = [follow.following for follow in user.from_user.all()]  # type: ignore
    categories = [
        *create_event_dicts(
            Event.objects.filter(authors__in=followed_users)[:3],
            "From People you Follow",
        ),
        *create_event_dicts(Event.objects.order_by("-date_created")[:15]),
    ]
    return categories


def get_user_research(user: CustomUser):
    return Event.objects.filter(authors=user).exclude(
        event_type__in=(
            EventTypes.WORKSHOP,
            EventTypes.CONFERENCE_EVENT,
            EventTypes.THESIS_SUPERVISION,
        ),
    )


def get_user_events(user: CustomUser):
    return Event.objects.filter(
        authors=user,
        event_type__in=(
            EventTypes.WORKSHOP,
            EventTypes.CONFERENCE_EVENT,
            EventTypes.THESIS_SUPERVISION,
        ),
    )


def exclude_keys(dictionary: dict, *keys):
    return {k: dictionary[k] for k in dictionary.keys() if k not in keys}
