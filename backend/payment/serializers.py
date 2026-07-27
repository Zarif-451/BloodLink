from rest_framework import serializers
from .models import Payment
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record


class PaymentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Payment
        fields = "__all__"
        read_only_fields = [
            "payment_ID"
        ]

    def create(self, validated_data):
        validated_data["payment_ID"] = generate_next_ID(
            "Payments", "payment_ID", "PAY"
        )
        row = insert_and_fetch("Payments", validated_data, model=Payment)
        return Payment(**row)

    def update(self, instance, validated_data):
        if "payment_ID" in validated_data:
            del validated_data["payment_ID"]

        update_record(
            "Payments",
            validated_data,
            ["payment_ID"],
            [instance.payment_ID],
            model=Payment
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance