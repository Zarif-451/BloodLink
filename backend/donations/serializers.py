from rest_framework import serializers
from .models import Donation, Screening
from utils.id_generator import generate_next_ID

class DonationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Donation
        fields = "__all__"
        read_only_fields = [
            "donation_ID"
        ]

    def create(self, validated_data):

        validated_data["donation_ID"] = generate_next_ID(
            Donation, "donation_ID", "DNT"
        )

        return Donation.objects.create(
            **validated_data
        )

class ScreeningSerializer(serializers.ModelSerializer):

    class Meta:
        model = Screening
        fields = "__all__"
        read_only_fields = [
            "screening_result_ID"
        ]
    
    def create(self, validated_data):

        validated_data["screening_result_ID"] = generate_next_ID(
            Screening, "screening_result_ID", "SCR"
        )

        return Screening.objects.create(
            **validated_data
        )