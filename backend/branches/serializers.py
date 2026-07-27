from rest_framework import serializers
from .models import Branch, BranchPhone
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record, model_from_row


class BranchSerializer(serializers.ModelSerializer):

    class Meta:
        model = Branch
        fields = "__all__"
        read_only_fields = [
            "branch_ID"
        ]

    def create(self, validated_data):
        validated_data["branch_ID"] = generate_next_ID(
            "Branches", "branch_ID", "BR"
        )

        row = insert_and_fetch("Branches", validated_data, model=Branch)
        return model_from_row(Branch, row)

    def update(self, instance, validated_data):
        if "branch_ID" in validated_data:
            del validated_data["branch_ID"]

        update_record(
            "Branches",
            validated_data,
            ["branch_ID"],
            [instance.branch_ID],
            model=Branch
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class BranchPhoneSerializer(serializers.ModelSerializer):

    class Meta:
        model = BranchPhone
        fields = "__all__"
        read_only_fields = [
            "branch_ID"
        ]

    def create(self, validated_data):
        row = insert_and_fetch("Branch_phone", validated_data, model=BranchPhone)
        return model_from_row(BranchPhone, row)

    def update(self, instance, validated_data):
        if "branch" in validated_data:
            del validated_data["branch"]

        update_record(
            "Branch_phone",
            validated_data,
            ["branch_ID", "phone"],
            [instance.branch_id, instance.phone],
            model=BranchPhone
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance