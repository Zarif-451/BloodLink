from rest_framework import serializers
from .models import BloodInventory, Allocation
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch, update_record


class BloodInventorySerializer(serializers.ModelSerializer):

    class Meta:
        model = BloodInventory
        fields = "__all__"
        read_only_fields = [
            "inventory_ID"
        ]

    def create(self, validated_data):
        validated_data["inventory_ID"] = generate_next_ID(
            "Blood_Inventory", "inventory_ID", "INV"
        )
        row = insert_and_fetch("Blood_Inventory", validated_data, model=BloodInventory)
        return BloodInventory(**row)

    def update(self, instance, validated_data):
        if "inventory_ID" in validated_data:
            del validated_data["inventory_ID"]

        update_record(
            "Blood_Inventory",
            validated_data,
            ["inventory_ID"],
            [instance.inventory_ID],
            model=BloodInventory
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance


class AllocationSerializer(serializers.ModelSerializer):

    request_ID = serializers.CharField(write_only=True)

    class Meta:
        model = Allocation
        fields = [
            "allocation_ID",
            "request_ID",
            "allocated_quantity",
            "allocation_date",
            "allocation_status",
        ]
        read_only_fields = [
            "allocation_ID",
            "allocated_quantity",
            "allocation_date",
            "allocation_status",
        ]

    def create(self, validated_data):
        row = insert_and_fetch("Allocations", validated_data, model=Allocation)
        return Allocation(**row)

    def update(self, instance, validated_data):
        if "allocation_ID" in validated_data:
            del validated_data["allocation_ID"]

        update_record(
            "Allocations",
            validated_data,
            ["allocation_ID"],
            [instance.allocation_ID],
            model=Allocation
        )

        for key, value in validated_data.items():
            setattr(instance, key, value)

        return instance