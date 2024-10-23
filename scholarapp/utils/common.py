from http import HTTPStatus
import itertools
import re
from typing import Iterable
from django.template.defaulttags import register
from django.http import HttpResponse

from scholarapp.models import Event


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
