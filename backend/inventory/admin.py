from django.contrib import admin
from .models import BloodInventory, Allocation

admin.site.register(BloodInventory)
admin.site.register(Allocation)