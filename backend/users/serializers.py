from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from utils.id_generator import generate_next_ID

from .models import User, Report, UserPhone

class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = "__all__"
        read_only_fields = [
            "user_ID"
        ]

        extra_kwargs = {
            "password" : {
                "write_only" : True
            }
        }

    def create(self, validated_data):

        validated_data["user_ID"] = generate_next_ID(
            User, "user_ID", "USR"
        )

        validated_data["password"] = make_password(
            validated_data["password"]
        )

        return User.objects.create(**validated_data)
    

    def update(self, instance, validated_data):
        
        if "password" in validated_data:

            validated_data["password"] = make_password(
                validated_data["password"]
            )

        
        return super().update(
            instance,
            validated_data
        )
    

class ReportSerializer(serializers.ModelSerializer):

    class Meta:
        model = Report
        fields = "__all__"
        read_only_fields = [
            "report_ID"
        ]


class UserPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserPhone
        fields = "__all__"
        read_only_fields = [
            "user_ID"
        ]