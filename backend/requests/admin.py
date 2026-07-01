from django.contrib import admin
from .models import Requester, Request

admin.site.register(Requester)
admin.site.register(Request)