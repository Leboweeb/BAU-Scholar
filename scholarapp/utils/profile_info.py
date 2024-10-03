from scholarapp.models import CustomUser, Profile


def create_user_profile(
    request_post_obj, labels: list[str], user_id: int
) -> dict[str, str]:
    form_values = [
        (
            "•".join(request_post_obj.getlist(l))
            if len(request_post_obj.getlist(l)) > 1
            else request_post_obj.getlist(l)[0]
        )
        for l in labels
    ]
    profile = {}
    profile["user"] = CustomUser.objects.filter(id=user_id).get()
    profile_fields = Profile._meta.get_fields()[2:-1]
    for index, field in enumerate(profile_fields):
        profile[field.attname] = form_values[index]  # type: ignore
    return profile
