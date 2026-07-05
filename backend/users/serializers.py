from rest_framework import serializers
from django.contrib.auth.hashers import make_password

from .models import User, Report, UserPhone

class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = "__all__"

    def create(self, validated_data):

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


class UserPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserPhone
        fields = "__all__"