from rest_framework import serializers
from .models import Branch, BranchPhone
from utils.id_generator import generate_next_ID

class BranchSerializer(serializers.ModelSerializer):

    class Meta:
        model = Branch
        fields = "__all__"
        read_only_fields = [
            "branch_ID"
        ]
    
    def create(
        self,
        validated_data
    ):

        validated_data["branch_ID"] = generate_next_ID(
            Branch,
            "branch_ID",
            "BR"
        )

        return Branch.objects.create(
            **validated_data
        )


class BranchPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = BranchPhone
        fields = "__all__"
        read_only_fields = [
            "branch_ID"
        ]