from rest_framework import serializers
from .models import Donation, Screening


class DonationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Donation
        fields = "__all__"


class ScreeningSerializer(serializers.ModelSerializer):

    class Meta:
        model = Screening
        fields = "__all__"