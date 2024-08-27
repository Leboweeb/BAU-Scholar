from datetime import datetime
from io import BytesIO
from xml.etree.ElementTree import Element
from docx import Document
from docx.shared import Inches
from docx.enum.style import WD_STYLE_TYPE


# document = Document("Staff Member Achievements Template.docx")
document = Document()


def generate_cv(publications: list[str], buffer: BytesIO):
    doc = Document()
    # Add title and heading
    current_year = datetime.now().year
    doc.add_heading("Staff Member Achievements", 0)
    doc.add_paragraph(f"Academic Year: {current_year} / {current_year+1}")

    # Add fields for Name, Position, and Faculty
    doc.add_paragraph("Name:")
    doc.add_paragraph("Position:")
    doc.add_paragraph("Faculty:")

    # Add section heading
    doc.add_heading("I. Teaching and Students", 1)

    # Add sub-items with bullet points
    doc.add_paragraph(
        "a) Contribute effectively to developing the faculty's curriculum at both program and departmental levels"
    )
    doc.add_paragraph(
        "b) Use a variety of advanced innovative learning methods - effective teaching (Please, give examples)"
    )
    doc.add_paragraph(
        "c) Use of students self learning methods in teaching (Please, give examples)"
    )
    doc.add_paragraph(
        "d) Support students effectively through academic advising and office hours."
    )
    doc.add_paragraph("e) Teaching load ( weekly )")
    doc.add_paragraph(
        "f) Quality Assurance Activities ( courses specification ,course report, ….     )"
    )
    doc.add_paragraph(
        "g) Contribute to students’ activities and communicate with them scientifically and academically "
    )
    doc.add_paragraph("h) Others")

    doc.add_heading("II. Scientific Research", 1)
    doc.add_paragraph("a) Scientific Publication")
    for publication in publications:
        doc.add_paragraph(publication, style="List Number 2")
    doc.add_paragraph("b) Conferences")
    doc.add_paragraph("c) Workshops")
    doc.add_paragraph("d) Supervision of Theses")
    doc.add_paragraph("e) Others")
    doc.add_heading("III. University and Community Services", 1)
    doc.add_paragraph("a) Participation in different committees (faculty- university)")
    doc.add_paragraph("b) Participation in community and cultural activities")
    doc.add_paragraph("c) Participation in conferences and workshops organization")
    doc.add_paragraph("d) Other services to the Lebanese society")
    doc.add_paragraph("e) Training and consultation")
    doc.add_paragraph("f) Others")
    # Save the document
    doc.save(buffer)
