from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record, model_from_row

from .models import User, Report, UserPhone


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = "__all__"
        read_only_fields = [
            "user_ID"
        ]
        extra_kwargs = {
            "password": {
                "write_only": True
            }
        }

    def create(self, validated_data):
        validated_data["user_ID"] = generate_next_ID(
            "Users", "user_ID", "USR"
        )

        validated_data["password"] = make_password(
            validated_data["password"]
        )

        row = insert_and_fetch("Users", validated_data, model=User)
        return model_from_row(User, row)

    def update(self, instance, validated_data):
        if "user_ID" in validated_data:
            del validated_data["user_ID"]

        if "password" in validated_data:
            validated_data["password"] = make_password(
                validated_data["password"]
            )

        update_record(
            "Users",
            validated_data,
            ["user_ID"],
            [instance.user_ID],
            model=User
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class ReportSerializer(serializers.ModelSerializer):

    class Meta:
        model = Report
        fields = "__all__"
        read_only_fields = [
            "report_ID"
        ]

    def create(self, validated_data):
        row = insert_and_fetch("Reports", validated_data, model=Report)
        return model_from_row(Report, row)

    def update(self, instance, validated_data):
        if "report_ID" in validated_data:
            del validated_data["report_ID"]

        update_record(
            "Reports",
            validated_data,
            ["report_ID"],
            [instance.report_ID],
            model=Report
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class UserPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserPhone
        fields = "__all__"
        read_only_fields = [
            "user"
        ]

    def create(self, validated_data):
        row = insert_and_fetch("User_phone", validated_data, model=UserPhone)
        return model_from_row(UserPhone, row)

    def update(self, instance, validated_data):
        if "user" in validated_data:
            del validated_data["user"]

        update_record(
            "User_phone",
            validated_data,
            ["user_ID", "phone"],
            [instance.user_id, instance.phone],
            model=UserPhone
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance