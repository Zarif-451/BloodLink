from rest_framework import serializers
from .models import Donor, DonorPhone

class DonorSerializer(serializers.ModelSerializer):

    class Meta:
        model = Donor
        fields = "__all__"

class DonorPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = DonorPhone
        fields = "__all__"
    