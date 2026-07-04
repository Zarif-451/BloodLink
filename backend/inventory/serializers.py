from rest_framework import serializers
from .models import BloodInventory, Allocation

class BloodInventorySerializer(serializers.ModelSerializer):

    class Meta:
        model = BloodInventory
        fields = "__all__"

class AllocationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Allocation
        fields = "__all__"