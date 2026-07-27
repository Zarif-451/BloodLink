from rest_framework import serializers
from .models import Donation, Screening
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record, model_from_row


class DonationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Donation
        fields = "__all__"
        read_only_fields = [
            "donation_ID"
        ]

    def create(self, validated_data):
        validated_data["donation_ID"] = generate_next_ID(
            "Donations", "donation_ID", "DNT"
        )

        row = insert_and_fetch("Donations", validated_data, model=Donation)
        return model_from_row(Donation, row)

    def update(self, instance, validated_data):
        if "donation_ID" in validated_data:
            del validated_data["donation_ID"]

        update_record(
            "Donations",
            validated_data,
            ["donation_ID"],
            [instance.donation_ID],
            model=Donation
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class ScreeningSerializer(serializers.ModelSerializer):

    class Meta:
        model = Screening
        fields = "__all__"
        read_only_fields = [
            "screening_result_ID"
        ]

    def create(self, validated_data):
        validated_data["screening_result_ID"] = generate_next_ID(
            "Screenings", "screening_result_ID", "SCR"
        )

        row = insert_and_fetch("Screenings", validated_data, model=Screening)
        return model_from_row(Screening, row)

    def update(self, instance, validated_data):
        if "screening_result_ID" in validated_data:
            del validated_data["screening_result_ID"]

        update_record(
            "Screenings",
            validated_data,
            ["screening_result_ID"],
            [instance.screening_result_ID],
            model=Screening
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance