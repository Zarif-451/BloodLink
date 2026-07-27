from rest_framework import serializers
from django.utils import timezone
from .models import Transport
from inventory.models import Allocation
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record, execute


class TransportSerializer(serializers.ModelSerializer):

    class Meta:
        model = Transport
        fields = "__all__"
        read_only_fields = [
            "transport_ID"
        ]

    def create(self, validated_data):
        validated_data["transport_ID"] = generate_next_ID(
            "Transports", "transport_ID", "TRN"
        )
        row = insert_and_fetch("Transports", validated_data, model=Transport)
        return Transport(**row)

    def update(self, instance, validated_data):
        old_status = instance.status

        new_status = validated_data.get("status", old_status)

        for key, value in validated_data.items():
            setattr(instance, key, value)

        if "transport_ID" in validated_data:
            del validated_data["transport_ID"]

        update_record(
            "Transports",
            validated_data,
            ["transport_ID"],
            [instance.transport_ID],
            model=Transport
        )

        if old_status != "In Transit" and new_status == "In Transit":
            execute(
                "UPDATE Allocations SET dispatched_time = %s WHERE transport_ID = %s AND dispatched_time IS NULL",
                [timezone.now(), instance.transport_ID]
            )

        if old_status != "Delivered" and new_status == "Delivered":
            execute(
                "UPDATE Allocations SET received_time = %s WHERE transport_ID = %s AND received_time IS NULL",
                [timezone.now(), instance.transport_ID]
            )
            execute(
                "UPDATE Allocations SET dispatched_time = %s WHERE transport_ID = %s AND dispatched_time IS NULL",
                [timezone.now(), instance.transport_ID]
            )

        return instance