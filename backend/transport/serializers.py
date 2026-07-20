from rest_framework import serializers

from .models import Transport
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