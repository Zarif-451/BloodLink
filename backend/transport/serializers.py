from rest_framework import serializers

from django.utils import timezone

from .models import Transport
from inventory.models import Allocation
from utils.id_generator import generate_next_ID


class TransportSerializer(serializers.ModelSerializer):

    class Meta:
        model = Transport
        fields = "__all__"

        read_only_fields = [
            "transport_ID"
        ]


    def create(self, validated_data):

        validated_data["transport_ID"] = generate_next_ID(
            Transport,
            "transport_ID",
            "TRN"
        )

        return Transport.objects.create(
            **validated_data
        )


    def update(self, instance, validated_data):

        old_status = instance.status

        transport = super().update(
            instance,
            validated_data
        )

        new_status = validated_data.get(
            "status",
            old_status
        )

        if old_status != "In Transit" and new_status == "In Transit":

            Allocation.objects.filter(
                transport=transport,
                dispatched_time__isnull=True
            ).update(
                dispatched_time=timezone.now()
            )

        if old_status != "Delivered" and new_status == "Delivered":

            Allocation.objects.filter(
                transport=transport,
                received_time__isnull=True
            ).update(
                received_time=timezone.now()
            )

            Allocation.objects.filter(
                transport=transport,
                dispatched_time__isnull=True
            ).update(
                dispatched_time=timezone.now()
            )

        return transport