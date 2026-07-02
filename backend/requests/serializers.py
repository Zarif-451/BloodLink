from rest_framework import serializers
from .models import Requester
from .models import Request

class RequesterSerializer(serializers.ModelSerializer):

    class Meta:
        model = Requester
        fields = "__all__"


class RequestSerializer(serializers.ModelSerializer):

    class Meta:
        model = Request
        fields = "__all__"