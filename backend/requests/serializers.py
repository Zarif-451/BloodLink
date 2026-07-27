from rest_framework import serializers
from .models import Requester, Request, RequesterPhone
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record


class RequesterSerializer(serializers.ModelSerializer):

    class Meta:
        model = Requester
        fields = "__all__"
        read_only_fields = [
            "requester_ID"
        ]

    def create(self, validated_data):
        validated_data["requester_ID"] = generate_next_ID(
            "Requesters", "requester_ID", "RQR"
        )
        row = insert_and_fetch("Requesters", validated_data, model=Requester)
        return Requester(**row)

    def update(self, instance, validated_data):
        if "requester_ID" in validated_data:
            del validated_data["requester_ID"]

        update_record(
            "Requesters",
            validated_data,
            ["requester_ID"],
            [instance.requester_ID],
            model=Requester
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class RequestSerializer(serializers.ModelSerializer):

    class Meta:
        model = Request
        fields = "__all__"
        read_only_fields = [
            "request_ID"
        ]

    def create(self, validated_data):
        validated_data["request_ID"] = generate_next_ID(
            "Requests", "request_ID", "REQ"
        )
        row = insert_and_fetch("Requests", validated_data, model=Request)
        return Request(**row)

    def update(self, instance, validated_data):
        if "request_ID" in validated_data:
            del validated_data["request_ID"]

        update_record(
            "Requests",
            validated_data,
            ["request_ID"],
            [instance.request_ID],
            model=Request
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class RequesterPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = RequesterPhone
        fields = "__all__"
        read_only_fields = [
            "requester"
        ]

    def create(self, validated_data):
        row = insert_and_fetch("Requester_phone", validated_data, model=RequesterPhone)
        return RequesterPhone(**row)

    def update(self, instance, validated_data):
        if "requester" in validated_data:
            del validated_data["requester"]

        update_record(
            "Requester_phone",
            validated_data,
            ["requester_ID", "phone"],
            [instance.requester_id, instance.phone],
            model=RequesterPhone
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance