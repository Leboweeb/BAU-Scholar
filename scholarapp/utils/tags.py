import json

from scholarapp.models import CustomUser

with open("scholarapp/utils/tags.json") as f:
    TAG_DICTIONARY = json.load(f)


def get_faculties():
    return [k for k in TAG_DICTIONARY]


def get_programs_for_departments(department: str):
    return [k for k in TAG_DICTIONARY[department]]


def get_tags_for_program(department: str, program: str):
    return TAG_DICTIONARY[department][program]


def get_programs_for_user(user: CustomUser):
    user_department = user.profile.department  # type: ignore
    return get_programs_for_departments(user_department)
