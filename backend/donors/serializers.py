from rest_framework import serializers
from .models import Donor, DonorPhone
from utils.db import insert_and_fetch, update_record, model_from_row


class DonorSerializer(serializers.ModelSerializer):

    class Meta:
        model = Donor
        fields = "__all__"

    def create(self, validated_data):
        row = insert_and_fetch("Donors", validated_data, model=Donor)
        return model_from_row(Donor, row)

    def update(self, instance, validated_data):
        if "national_ID" in validated_data:
            del validated_data["national_ID"]

        update_record(
            "Donors",
            validated_data,
            ["national_ID"],
            [instance.national_ID],
            model=Donor
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class DonorPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = DonorPhone
        fields = "__all__"

    def create(self, validated_data):
        row = insert_and_fetch("Donor_phone", validated_data, model=DonorPhone)
        return model_from_row(DonorPhone, row)

    def update(self, instance, validated_data):
        if "donor" in validated_data:
            del validated_data["donor"]

        update_record(
            "Donor_phone",
            validated_data,
            ["national_ID", "phone"],
            [instance.donor_id, instance.phone],
            model=DonorPhone
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance