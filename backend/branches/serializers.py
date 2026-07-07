from rest_framework import serializers
from .models import Branch, BranchPhone

class BranchSerializer(serializers.ModelSerializer):

    class Meta:
        model = Branch
        fields = "__all__"

class BranchPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = BranchPhone
        fields = "__all__"