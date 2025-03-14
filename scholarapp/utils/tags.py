import json
import google.generativeai as genai
from scholarapp.models import CustomUser

with open("scholarapp/utils/tags.json") as f:
    TAG_DICTIONARY = json.load(f)


def get_faculties():
    return [k for k in TAG_DICTIONARY]


def get_programs_for_departments(department: str):
    return [k for k in TAG_DICTIONARY[department]]


def get_tags_for_department(faculty: str, department: str):
    return TAG_DICTIONARY[faculty][department]


def get_department_for_user(user: CustomUser):
    user_faculty = user.profile.faculty  # type: ignore
    return get_programs_for_departments(user_faculty)


def generate_response(title: str, tags: list[str]):
    gen_model = genai.GenerativeModel()
    try:
        return gen_model.generate_content(
            """
                                    {}
                                    Based on the earlier title or description, generate only a string that contains the minimum amount of tags associated with these options : {} joined by the • character. If there is no text or random text, return an empty string
                                    """.format(
                title, tags
            )
        ).text
    except Exception as e:
        return ""
