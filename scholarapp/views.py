import base64
import json
import os
import operator
import pathlib
from datetime import datetime
from functools import reduce
from http import HTTPStatus
from io import BytesIO
from itertools import chain
from django.db.models import Q, Count
from dateutil.parser import parse
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib.auth.views import LoginView, PasswordResetView
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.utils.text import slugify
from django.template.defaulttags import register
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
import google.generativeai as genai
from BAU_Scholar import settings
from scholarapp.forms import CreateEventForm, SignUpForm
from scholarapp.models import (
    Conversation,
    CustomUser,
    EventTypes,
    Followers,
    Profile,
    Event,
)
from scholarapp.serializers import ImportUserSerializer
from dotenv import load_dotenv
from scholarapp.utils.common import (
    as_id,
    create_event_dicts,
    exclude_keys,
    join_with_dot,
    return_with_code,
    return_with_no_content,
    save_user_image,
    split_at_dot,
    zip_if_equal,
)
from scholarapp.utils.document_utils import (
    cv_json_to_cv_profile,
    generate_cv,
    generate_document_json,
    generate_form_fields,
    generate_staff_achievements,
)
from scholarapp.utils.scrape_user import (
    ImportBackend,
    get_scraper,
)
from scholarapp.utils.profile_info import create_user_profile
from scholarapp.utils.tags import (
    get_faculties,
    get_programs_for_user,
    get_tags_for_program,
)

load_dotenv()

current_year = datetime.now().year
staff_achievement_labels = [
    "Contribute effectively to developing the faculty’s curriculum at both program and departmental levels",
    "Use a variety of advanced innovative learning methods- effective teaching",
    "Use of students self learning methods in teaching",
    "Support students effectively through academic advising and office hours.",
    "Teaching load ( weekly )",
    "Quality Assurance Activities ( courses specification ,course report, ….     )",
    "Contribute to students’ activities and communicate with them scientifically and academically",
    "Others ( First Section )",
    "Others ( Second Section )",
    "Participation in different committees ( faculty - university )",
    "Participation in community and cultural activities",
    "Participation in conferences and workshops organization",
    "Other services to the Lebanese society",
    "Training and consultation",
    "Others ( Third Section )",
]

cv_labels = [
    {"label": "Rank", "required": True, "single": True},
    {
        "label": "Department",
        "required": True,
        "single": True,
        "select": True,
        "choices": get_faculties(),
    },
    {"label": "Program", "required": True, "single": True, "select": True},
    {"label": "Research Interests", "required": False, "single": True},
    {"label": "Rank Link", "required": False, "single": True},
    {
        "label": "Tags",
        "required": False,
        "single": True,
        "autocomplete": True,
        "endpoint": "/search_tags",
        "top": "42px",
    },
    {"label": "Skills", "required": False, "single": False},
    {"label": "Education", "required": False, "single": False},
    {"label": "Academic Experience", "required": False, "single": False},
    {"label": "Non Academic Experience", "required": False, "single": False},
    {"label": "Certifications", "required": False, "single": False},
    {"label": "Organization Membership", "required": False, "single": False},
    {"label": "Honors and Awards", "required": False, "single": False},
    {"label": "Service Activities", "required": False, "single": False},
    {"label": "Experience Courses", "required": False, "single": False},
    {"label": "References", "required": False, "single": False},
    {
        "label": "Professional Development Activities",
        "required": False,
        "single": False,
    },
]


events_with_participants = [
    EventTypes.WORKSHOP,
    EventTypes.CONFERENCE_EVENT,
    EventTypes.THESIS_SUPERVISION,
]


# env vars to make gemini less noisy
os.environ["GRPC_VERBOSITY"] = "ERROR"
os.environ["GLOG_minloglevel"] = "2"
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=GOOGLE_API_KEY)


def get_home_feed(user: CustomUser):
    followed_users = [follow.following for follow in user.from_user.all()]  # type: ignore
    followed_events = Event.objects.filter(authors__in=followed_users)[:3]
    user_tags = split_at_dot(user.profile.tags)  # type: ignore
    recommended_events_queries = reduce(
        operator.or_, (Q(tags__icontains=tag) for tag in user_tags)
    )
    recommended_events = Event.objects.filter(recommended_events_queries).exclude(
        authors=user
    )[:3]
    exclude_event_ids = [i.pk for i in list(chain(followed_events, recommended_events))]
    categories = [
        *create_event_dicts(
            followed_events,
            "From People you Follow",
        ),
        *create_event_dicts(recommended_events, "Recommended For You"),
        *create_event_dicts(Event.objects.exclude(id__in=exclude_event_ids)[:15]),
    ]
    return categories


def modular_tag_search(request, query, department, program):
    if not department or not program:
        return return_with_code(HTTPStatus.BAD_REQUEST)
    if not query:
        tags = []
    else:
        tags = [
            tag
            for tag in get_tags_for_program(department, program)
            if query.lower() in tag.lower()
        ]
    return render(request, "components/search_tags.html", context={"tags": tags})


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


# Create your views here.
@register.filter(name="split")
def split(value: str, key):
    """
    Returns the value turned into a list.
    """
    return value.split(key)


@register.filter(name="can_participate")
def can_participate_in_event(value: EventTypes):
    if value in events_with_participants:
        return True
    return False


@register.filter(name="user_has_participated")
def has_participated(user: CustomUser, event_id: int):
    return Event.objects.filter(id=event_id, attendees=user)


@register.filter(name="get_event_info")
def get_event_info(event_id):
    event_id = int(event_id)
    event = Event.objects.get(id=event_id)
    event_type_dict = {choice.value: choice.label for choice in EventTypes}
    return json.dumps(
        {
            "title": event.title,
            "description": event.description,
            "event_type": str(event_type_dict[event.event_type]),
            "tags": event.tags,
            "authors": [[author.id, author.name] for author in event.authors.all()],
            "event_id": event_id,
        }
    )


@register.simple_tag
def get_group_or_proxy(group: Conversation, user_id: int, group_attr, attr):
    if len(group.users.all()) >= 3:
        return getattr(group, group_attr) or ""
    else:
        return getattr(group.users.exclude(id=user_id)[0], attr)


def test(request):
    labels = [
        "International Faculty Ratio",
        "International Student Ratio",
        "Employment Outcomes",
        "International Research Network",
    ]
    stats = [88.5, 48.2, 38.2, 28]
    faculties = get_faculties()
    if request.path == "/dashboard/statistics":
        template = "admin/admin_statistics.html"
    else:
        template = "admin/admin_staff_achievements.html"

    return render(
        request,
        template,
        context={"stats": dict(zip(labels, stats)), "faculties": faculties},
    )


@login_required
def index(request):
    categories = get_home_feed(request.user)
    return render(
        request,
        "home.html",
        context={
            "user": request.user,
            "categories": categories,
            "current_year": current_year,
        },
    )


@login_required
def profile(request, user_id: str):
    user = CustomUser.objects.get(pk=user_id)
    is_current_user = request.user == user
    is_following_user = request.user.from_user.filter(following_id=user.pk).exists()
    user_publications = Event.objects.filter(authors=user).exclude(
        event_type__in=events_with_participants
    )
    user_events = Event.objects.filter(
        authors=user, event_type__in=events_with_participants
    )
    post_sign_up = request.GET.get("postsignup", None)
    user_profile_fields, staff_achievement_values = generate_form_fields(user_id)
    context = {
        "user": user,
        "publications": user_publications.all(),
        "user_events": user_events.all(),
        "is_current_user": is_current_user,
        "is_following": is_following_user,
        "form": CreateEventForm(),
        "data": user_profile_fields,
        "get_faculties": get_faculties,
        "user_programs": (
            get_programs_for_user(request.user)
            if request.user.profile.department
            else ""
        ),
        # "cv_records": zip_if_equal(cv_labels, user_profile_fields),
        "staff_achievement_records": zip_if_equal(
            staff_achievement_labels,
            staff_achievement_values,
        ),
        "current_year": current_year,
        "options": CustomUser.objects.all(),
        "event_types": {choice.label: choice for choice in EventTypes},
        "postsignup": post_sign_up,
    }
    if request.method == "POST":
        eventForm = CreateEventForm(request.POST)
        if eventForm.is_valid():
            event_keys = exclude_keys(eventForm.cleaned_data, "authors")
            event = Event.objects.create(**event_keys)
            if tags := request.POST.get("hidden_eventtags"):
                event.tags = tags
            authors = request.POST.get("hidden_authors")
            if not authors:
                # the event creator is assumed to be the author
                # in case someone tries to be funny
                event.authors.add(request.user)
            else:
                # javascript validation saved us, we don't have any shennanigans
                for author_id in map(int, authors.split(",")):
                    event.authors.add(CustomUser.objects.get(id=author_id))
            event.save()
    return render(request, "profile.html", context=context)


@login_required
def follow_status(request, to_user_id: int, status: str):
    to_user = get_object_or_404(CustomUser, id=to_user_id)
    if status == "follow":
        if not request.user.from_user.filter(following_id=to_user_id).exists():
            Followers.objects.create(follower=request.user, following=to_user)
    elif status == "unfollow":
        request.user.from_user.filter(following_id=to_user_id).delete()
    return redirect("profile", user_id=to_user_id)


@api_view(["POST"])
def get_chat_history(request):
    slug = request.data["conversation_slug"]
    conversation = Conversation.objects.get(room_slug=slug)
    return render(
        request,
        "message_history.html",
        context={"messages": conversation.message_set.all(), "user_id": request.user.pk},  # type: ignore
    )


@api_view(["POST"])
def generate_user_document(request):
    document_generator = [
        generate_cv,
        generate_staff_achievements,
    ][int(request.data["selected_document"])]
    user = CustomUser.objects.get(pk=int(request.data["user_id"]))
    user_publications = [
        (f"{publication.author_str} : {publication.title}\n\n")
        for publication in Event.objects.filter(authors=user).exclude(
            event_type__in=(
                EventTypes.WORKSHOP,
                EventTypes.CONFERENCE_EVENT,
                EventTypes.THESIS_SUPERVISION,
            ),
        )
    ]
    buffer = BytesIO()
    # docx is saved to buffer now
    document_generator(request.user, user_publications, buffer)
    b64_data = base64.b64encode(buffer.getvalue())
    return JsonResponse({"data": b64_data.decode()})


@api_view(["POST"])
def participate_in_event(request):
    event_id = request.data["event_id"]
    _has_participated = request.data["has_participated"]
    user = CustomUser.objects.get(pk=request.user.pk)
    event = Event.objects.get(pk=event_id)
    if not _has_participated:
        event.attendees.add(user)
    else:
        event.attendees.remove(user)
    # Same as 200, but client doesn't expect HTML or JSON as response.
    return return_with_no_content()


def update_profile(request):
    user = CustomUser.objects.get(id=request.user.pk)
    if request.POST:
        personal_info_labels = [
            "rank",
            "department",
            "program",
            "researchinterests",
            "ranklink",
            "hidden_tags",
            "skills",
            "education",
            "academicexperience",
            "nonacademicexperience",
            "certifications",
            "organizationmembership",
            "honorsandawards",
            "serviceactivities",
            "experiencecourses",
            "references",
            "professionaldevelopmentactivities",
        ]
        Profile.objects.filter(pk=user.profile.pk).update(  # type: ignore
            **create_user_profile(request.POST, personal_info_labels)
        )
        # user.profile referes to the old user object, use the request.user object to get the most recent version instead
        response = render(
            request,
            "components/profile/profile_tags_skills_fragment.html",
            context={"user_profile": request.user.profile, "is_current_user": True},  # type: ignore
        )
        return response
    elif request.FILES:
        file = request.FILES.get("imported_document")
        file_name = file.name.lower()
        if file_name.find("achievements") > -1:
            cv_json = generate_document_json(
                [
                    "Contribute effectively to developing the faculty’s curriculum at both program and departmental levels",
                    "Use a variety of advanced innovative learning methods- effective teaching",
                    "Use of students self learning methods in teaching",
                    "Support students effectively through academic advising and office hours.",
                    "Teaching load ( weekly )",
                    "Quality Assurance Activities ( courses specification ,course report, ….     )",
                    "Contribute to students’ activities and communicate with them scientifically and academically",
                    "Others ( First Section )",
                    "Scientific publication",
                    "Conferences",
                    "Workshops",
                    "Supervision of theses",
                    "Others ( Second Section )",
                    "Participation in different committees ( faculty - university )",
                    "Participation in community and cultural activities",
                    "Participation in conferences and workshops organization",
                    "Other services to the Lebanese society",
                    "Training and consultation",
                    "Others ( Third Section )",
                ],
                file,
                [
                    "Scientific publication",
                    "Conferences",
                    "Workshops",
                    "Supervision of theses",
                ],
            )
            generated_profile = {
                "staff_member_achievements": join_with_dot(
                    [cv_json[key][0] for key in cv_json]
                )
            }
        else:
            cv_json = generate_document_json(
                [
                    "Name and Academic rank:",
                    "Education: Degrees, discipline, institution, and date:",
                    "Academic experience",
                    "Non-academic experience",
                    "Certification or professional Registration",
                    "Current membership in professional organizations",
                    "Honors and Awards:",
                    "Service activities",
                    "Experience Courses (Graduate and Undergraduate)",
                    "Research	Interests",
                    "References:",
                    "Rank Link:",
                    "Publications",
                    "Professional development activities in the last years",
                ],
                file,
                ["Publications"],
            )
            generated_profile = cv_json_to_cv_profile(cv_json)

        Profile.objects.filter(pk=user.profile.pk).update(  # type: ignore
            **generated_profile
        )
        # fetch user profile after update
        user_profile_fields, staff_achievement_values = generate_form_fields(
            request.user.pk
        )
        response = render(
            request,
            "update_info.html",
            context={
                "cv_records": zip_if_equal(cv_labels, user_profile_fields),
                "staff_achievement_records": zip_if_equal(
                    staff_achievement_labels, staff_achievement_values
                ),
            },
        )
        return response
    else:
        return return_with_no_content()


@api_view(["POST"])
def get_events(request):
    if query := request.POST.get("event_search"):
        search_method = request.POST.get("search_in") or "title"
        sort_by = request.POST.get("sort_by") or "most_recent"
        sort_by = "-date_created" if sort_by == "most_recent" else "date_created"
        event_objects = Event.objects
        match search_method:

            case "title":
                event_objects = event_objects.filter(title__icontains=query)

            case "people":
                authors = CustomUser.objects.filter(name__icontains=query)[:10]
                if not authors.exists():
                    # user is most likely searching for tagged users
                    authors = [
                        p.user for p in Profile.objects.filter(tags__icontains=query)
                    ]
                return render(
                    request,
                    "search_authors_home.html",
                    context={"authors": authors},
                )

            case "research":
                event_objects = get_user_research(request.user).filter(
                    title__icontains=query
                )

            case "events":
                event_objects = get_user_events(request.user).filter(
                    title__icontains=query
                )

            case "tags":
                event_objects = event_objects.filter(tags__icontains=query)

        event_objects = event_objects.order_by(sort_by)

        categories = create_event_dicts(
            event_objects
            # Event.objects.filter(title__icontains=query).order_by(sort_by)
        )
    else:
        categories = get_home_feed(request.user)
    return render(
        request,
        "components/render_events.html",
        context={"categories": categories},
    )


@api_view(["POST"])
def search_tags(request):
    department, program = (
        request.POST.get(string) or "" for string in ("department", "program")
    )
    query = request.POST.get("tags") or ""
    return modular_tag_search(request, query, department, program)


@api_view(["POST"])
def search_tags_for_user(request):
    query = ""
    for key in request.POST:
        if "tags" in key and "hidden" not in key:
            query = request.POST.get(key)
    user_profile = request.user.profile
    department = user_profile.department
    program = user_profile.program
    return modular_tag_search(request, query, department, program)


@api_view(["POST"])
def search_users(request):
    author = ""
    for key in request.POST:
        if "author" in key and "hidden" not in key:
            author = request.POST.get(key)
    if not author:
        return return_with_no_content()
    authors = CustomUser.objects.filter(name__icontains=author)[:5]
    return render(
        request, "components/search_contacts.html", context={"contacts": authors}
    )


@api_view(["POST"])
def get_groups(request):
    user = CustomUser.objects.get(pk=int(request.user.pk))
    user_groups = Conversation.objects.filter(users=user)
    if request.POST.get("chat_search"):
        name_to_search = request.POST.get("chat_search")
        chat_searches = Conversation.objects.annotate(
            users_count=Count("users")
        ).filter(users_count__lt=3, room_slug__icontains=name_to_search)[:3]
        group_results = Conversation.objects.filter(title__icontains=name_to_search)[:2]
        groups = list(chain(chat_searches, group_results))
    else:
        groups = user_groups[:5]

    return render(
        request,
        "components/groups.html",
        context={
            "groups": groups,
        },
    )


@api_view(["POST"])
def create_conversation_room(request):
    user_ids = [int(_id) for _id in request.data["user_ids"]]
    if len(user_ids) > 8:
        return HttpResponse(
            {"error_reason": "Too many group members !"},
            status=HTTPStatus.BAD_REQUEST.value,
        )
    extra_fields = [
        request.data.get(as_id(title)) for title in ("Group Title", "Group Description")
    ]
    # if we have an empty title or description, return error.
    if len(user_ids) >= 3:
        if any(not field for field in extra_fields):
            return HttpResponse(
                {"error_reason": "Title or description for conversation is empty!"},
                status=HTTPStatus.BAD_REQUEST.value,
            )
        elif Conversation.objects.filter(title=extra_fields[0]):
            return HttpResponse(
                {"error_reason": " Group already exists !"},
                status=HTTPStatus.BAD_REQUEST.value,
            )

    # otherwise proceed normally
    conversation = Conversation.objects.create()
    if len(user_ids) >= 3:
        conversation.title = extra_fields[0]
        conversation.description = extra_fields[1]
    for user in [CustomUser.objects.get(id=_id) for _id in user_ids]:
        conversation.users.add(user)
    conversation.room_slug = slugify(
        "_".join(user.name for user in conversation.users.all())
    )
    conversation.save()
    user_groups = Conversation.objects.filter(users=user)[:5]
    response = render(
        request, "components/groups.html", context={"groups": user_groups}
    )
    return response


@api_view(["POST"])
def update_event(request):
    event_id = int(request.POST.get("hidden_event_id"))
    event = get_object_or_404(Event, id=event_id)
    if tags := request.POST.get("hidden_editeventtags"):
        event.tags = tags
    authors = request.POST.get("hidden_editauthors")
    if not authors:
        # the event creator is assumed to be the author
        # in case someone tries to be funny
        event.authors.add(request.user)
    else:
        # javascript validation saved us, we don't have any shennanigans
        author_objects = [
            CustomUser.objects.get(id=author_id)
            for author_id in map(int, split_at_dot(authors))
        ]
        event.authors.set(author_objects)
    event.save()
    user_publications = Event.objects.filter(authors=request.user).exclude(
        event_type__in=events_with_participants
    )
    user_events = Event.objects.filter(
        authors=request.user, event_type__in=events_with_participants
    )
    return render(
        request,
        "components/profile/profile_events.html",
        context={
            "publications": user_publications.all(),
            "user_events": user_events.all(),
        },
    )


@api_view(["POST"])
def import_user(request):
    serializer = ImportUserSerializer(data=request.data)
    if request.method == "POST":
        if serializer.is_valid():
            name = serializer.validated_data["name"]  # type: ignore
            backend = serializer.validated_data["backend"]  # type: ignore
            if backend == ImportBackend.RESEARCHGATE.value:
                if name in list(
                    map(
                        lambda file: file.replace(".json", ""),
                        os.listdir("./scholarapp/cached"),
                    )
                ):
                    with open(f"./scholarapp/cached/{name}.json") as f:
                        return Response(json.load(f))
            else:
                scraper = get_scraper(backend)
                scraped_profiles = scraper.scrape_user(name)
                return Response(scraped_profiles)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def sign_in(request):
    if request.method == "POST":
        form = SignUpForm(request.POST)
        if form.is_valid():
            model = form.save(commit=False)
            # scrape publications in the sign in phase, no need to pass around args
            # no need to store research gate profile URL either
            attrs = ("skills",)
            for attr in attrs:
                setattr(model, attr, request.POST.get(attr))
            model.save()
            profile_temp = Profile(user_id=model.pk)
            profile_temp.save()
            model.profile = profile_temp
            import_backend = request.POST.get("import_backend", None)
            profile_url_or_name = request.POST.get("profile_url", None) or model.name
            assert profile_url_or_name
            avatar = request.POST.get("avatar", None)
            if avatar:
                save_user_image(avatar, model.name)
                new_path = str(
                    (
                        pathlib.Path(settings.MEDIA_ROOT) / f"uploads/{model.name}.jpg"
                    ).resolve()
                )
                with open(new_path, "rb") as fd:
                    model.avatar.save(f"{model.name}.jpg", fd, True)
            scraper = get_scraper(import_backend)
            scraped_publications = scraper.scrape_publications(profile_url_or_name)
            event_types = {choice.label: choice for choice in EventTypes}

            publication_pairs = []
            for publication in scraped_publications:
                if not publication:
                    continue
                else:
                    publication_pairs.append(
                        Event.objects.get_or_create(
                            title=publication["title"],
                            description=publication["description"],
                            date_created=parse(publication["date_created"]),
                            event_type=event_types[publication["research_type"]],
                        )
                    )

            for publication, _ in publication_pairs:
                publication.authors.add(model)
            return redirect(f"/profile/{model.pk}?postsignup=true")
        return render(request, "registration/signup.html", context={"form": form})
    else:
        form = SignUpForm()
        request.session["next"] = request.GET.get("next", "/")
        return render(
            request,
            "registration/signup.html",
            context={"form": form},
        )


class MyLoginView(LoginView):
    redirect_authenticated_user = True

    def get_success_url(self):
        return reverse_lazy("/")

    def form_invalid(self, form):
        messages.error(self.request, "Invalid username or password")
        return self.render_to_response(self.get_context_data(form=form))


class CustomResetPasswordView(PasswordResetView):
    template_name = "registration/password_reset.html"
    html_email_template_name = "registration/password_reset_email.html"
    extra_email_context = {"current_year": current_year}
