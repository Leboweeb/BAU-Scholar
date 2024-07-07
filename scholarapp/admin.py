# Register your models here.
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from scholarapp.models import CustomUser


@admin.register(CustomUser)
class CustomAdmin(BaseUserAdmin):
    list_display = ["email"]
    ordering = ["email"]
