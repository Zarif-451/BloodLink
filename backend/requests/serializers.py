from rest_framework import serializers
from .models import Requester
from .models import Request, RequesterPhone
from utils.id_generator import generate_next_ID

class RequesterSerializer(serializers.ModelSerializer):

    class Meta:
        model = Requester
        fields = "__all__"
        read_only_fields = [
            "requester_ID"
        ]

    def create(self, validated_data):

        validated_data["requester_ID"] = generate_next_ID(
            Requester, "requester_ID", "RQR"
        )

        return Requester.objects.create(
            **validated_data
        )

class RequestSerializer(serializers.ModelSerializer):

    class Meta:
        model = Request
        fields = "__all__"
        read_only_fields = [
            "request_ID"
        ]

    def create(self, validated_data):

        validated_data["request_ID"] = generate_next_ID(
            Requester, "requester_ID", "REQ"
        )

        return Requester.objects.create(
            **validated_data
        )

class RequesterPhoneSerializer(serializers.ModelSerializer):

    class Meta:

        model = RequesterPhone
        fields = "__all__"
        read_only_fields = [
            "requester_ID"
        ]