from datetime import datetime
from io import BytesIO
import re
from docx import Document
from scholarapp.models import CustomUser, Profile
from django.db import models

from scholarapp.utils.common import split_at_dot


# document = Document("Staff Member Achievements Template.docx")
document = Document()


def generate_cv(user: CustomUser, publications: list[str], buffer: BytesIO):
    current_year = datetime.now().year
    user_profile: Profile = user.profile  # type: ignore
    if not user_profile:
        raise Exception("Couldn't find user profile!")
    document = Document()
    document.add_heading(
        f"\t\t\tBeirut Arab University\n\t\t\tFaculty CV\n\t\t\tYear {current_year}/{current_year+1}",
        0,
    )
    document.add_paragraph("Name and Academic rank:", style="List Number")
    document.add_paragraph(
        f"{user.name}, {user_profile.rank} , {user_profile.department}, Beirut Arab University"
    )
    document.add_paragraph(
        "Education: Degrees, discipline, institution, and date:", style="List Number"
    )
    for i in user_profile.education.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph("Academic experience:", style="List Number")
    for i in user_profile.education.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph("Non-academic experience:", style="List Number")
    for i in user_profile.non_academic_experience.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph(
        "Certification or professional Registration:", style="List Number"
    )
    for i in user_profile.certifications.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph(
        "Current membership in professional organizations", style="List Number"
    )
    for i in user_profile.memberships.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph("Honors and Awards:", style="List Number")
    for i in user_profile.honors.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph("Service activities:", style="List Number")
    for i in user_profile.service_activities.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph(
        "Experience Courses (Graduate and Undergraduate)", style="List Number"
    )
    for i in user_profile.courses.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph("Research	Interests:", style="List Number")
    document.add_paragraph("References:", style="List Number")
    for i in user_profile.references.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.add_paragraph("Rank Link:", style="List Number")
    document.add_paragraph(user_profile.rank_link, style="List Bullet 2")
    document.add_paragraph("Publications:", style="List Number")
    for publication in publications:
        document.add_paragraph(publication, style="List Number 2")
    document.add_paragraph(
        "Professional development activities in the last years:", style="List Number"
    )
    for i in user_profile.development_activities.split("•"):
        document.add_paragraph(i, style="List Bullet 2")
    document.save(buffer)


def generate_staff_achievements(
    user: CustomUser, publications: list[str], buffer: BytesIO
):
    doc = Document()

    def get_profile_field_or_blank(attr: str | None = None, index: int | None = None):
        """
        Use this function to access an attribute in the user profile object or a field
        in the staff achievements list but not both. Returns `""` otherwise
        """
        if hasattr(user, "profile"):
            user_profile: Profile = user.profile  # type: ignore

            if index != None and attr == None:
                return split_at_dot(user_profile.staff_member_achievements)[index]
            elif attr != None and index == None:
                return getattr(user_profile, attr, "")
            return ""
        return ""

    # Add title and heading
    current_year = datetime.now().year
    doc.add_heading("Staff Member Achievements", 0)
    doc.add_paragraph(f"Academic Year: {current_year} / {current_year+1}")

    # Add fields for Name, Position, and Faculty
    doc.add_paragraph("Name:")
    doc.add_paragraph(f"{user.name}")
    doc.add_paragraph("Position:")
    doc.add_paragraph(f"{get_profile_field_or_blank('rank')}")
    doc.add_paragraph("Faculty:")
    doc.add_paragraph(f"{get_profile_field_or_blank('department')}")

    # Add section heading

    doc.add_heading("I. Teaching and Students", 1)

    # # Add sub-items with bullet points
    doc.add_paragraph(
        "a) Contribute effectively to developing the faculty’s curriculum at both program and departmental levels"
    )
    doc.add_paragraph(f"{get_profile_field_or_blank(index=0)}")
    doc.add_paragraph(
        "b) Use a variety of advanced innovative learning methods- effective teaching"
    )

    doc.add_paragraph(f"{get_profile_field_or_blank(index=1)}")
    doc.add_paragraph("c) Use of students self learning methods in teaching")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=2)}")
    doc.add_paragraph(
        "d) Support students effectively through academic advising and office hours."
    )

    doc.add_paragraph(f"{get_profile_field_or_blank(index=3)}")
    doc.add_paragraph("e) Teaching load ( weekly ) ")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=4)}")
    doc.add_paragraph(
        "f) Quality Assurance Activities ( courses specification ,course report, ….     )"
    )

    doc.add_paragraph(f"{get_profile_field_or_blank(index=5)}")
    doc.add_paragraph(
        "g) Contribute to students’ activities and communicate with them scientifically and academically"
    )

    doc.add_paragraph(f"{get_profile_field_or_blank(index=6)}")
    doc.add_paragraph("h) Others ( First Section )")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=7)}")
    doc.add_heading("II. Scientific Research", 1)
    doc.add_paragraph("a) Scientific publication")
    for publication in publications:
        doc.add_paragraph(publication, style="List Number 2")
    doc.add_paragraph("b) Conferences")
    doc.add_paragraph("c) Workshops")
    doc.add_paragraph("d) Supervision of theses")
    doc.add_paragraph("e) Others ( Second Section )")
    doc.add_paragraph(f"{get_profile_field_or_blank(index=8)}")
    doc.add_heading("III. University and Community Services", 1)
    doc.add_paragraph(
        "a) Participation in different committees ( faculty - university )"
    )

    doc.add_paragraph(f"{get_profile_field_or_blank(index=9)}")
    doc.add_paragraph("b) Participation in community and cultural activities")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=10)}")
    doc.add_paragraph("c) Participation in conferences and workshops organization")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=11)}")
    doc.add_paragraph("d) Other services to the Lebanese society")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=12)}")
    doc.add_paragraph("e) Training and consultation")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=13)}")
    doc.add_paragraph("f) Others ( Third Section )")

    doc.add_paragraph(f"{get_profile_field_or_blank(index=14)}")
    # Save the document
    doc.save(buffer)


def generate_document_json(
    labels: list[str], file: BytesIO, labels_to_remove: list[str]
):
    roman_numerals = [
        "I.",
        "II.",
        "III.",
        "IV.",
        "V.",
        "VI.",
        "VII.",
        "VIII.",
        "IX.",
        "X.",
    ]
    document = Document(file)
    document_dict = {label: [] for label in labels}
    document_dict["_meta"] = []
    current_label = "_meta"
    for p in document.paragraphs:
        processed_text = re.sub(r"(\d+\.|\w+\))", "", p.text).strip()
        # we don't care about headings
        if any(processed_text.startswith(numeral) for numeral in roman_numerals):
            document_dict["_meta"].append(p.text)
            continue
        # we don't care about line breaks
        if not processed_text:
            continue
        if processed_text in labels:
            current_label = processed_text
        else:
            document_dict[current_label].append(p.text.strip())

    for label in labels_to_remove + ["_meta"]:
        del document_dict[label]
    return document_dict


def cv_json_to_cv_profile(input_dict: dict[str, list]):
    # handle text fields first
    required_multi_value_labels = [
        "Education: Degrees, discipline, institution, and date:",
        "Academic experience",
        "Non-academic experience",
        "Certification or professional Registration",
        "Current membership in professional organizations",
        "Honors and Awards:",
        "Service activities",
        "Experience Courses (Graduate and Undergraduate)",
        "References:",
        "Professional development activities in the last years",
    ]
    multi_values_fields = [
        input_dict[key] for key in input_dict if key in required_multi_value_labels
    ]
    update_dict = {}
    text_fields = [
        field
        for field in Profile._meta.get_fields()
        if isinstance(field, models.TextField)
    ][:-1]

    for field, value in zip(text_fields, multi_values_fields):
        update_dict[field.attname] = "•".join(value)

    # then handle special cases
    update_dict["rank_link"] = input_dict["Rank Link:"][0]
    update_dict["research_interests"] = input_dict["Research\tInterests"][0]
    _, rank, department, _ = input_dict["Name and Academic rank:"][0].split(",")
    update_dict["rank"] = rank
    update_dict["department"] = department
    return update_dict


def generate_form_fields(user_id: int | str):
    user = CustomUser.objects.get(pk=user_id)
    if hasattr(user, "profile"):
        user_profile: Profile = user.profile  # type: ignore
        user_profile_fields = [
            getattr(user_profile, attr.attname).split("•")  # type: ignore
            for attr in Profile._meta.get_fields()[2:-1]
        ]
        staff_achievement_values = split_at_dot(user_profile.staff_member_achievements)
    else:
        user_profile_fields = []
        staff_achievement_values = []

    return user_profile_fields, staff_achievement_values
