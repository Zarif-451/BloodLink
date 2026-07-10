from rest_framework import serializers
from .models import BloodInventory, Allocation
from utils.id_generator import generate_next_ID

class BloodInventorySerializer(serializers.ModelSerializer):

    class Meta:
        model = BloodInventory
        fields = "__all__"
        read_only_fields = [
            "inventory_ID"
        ]

    def create(self, validated_data):

        validated_data["inventory_ID"] = generate_next_ID(
            BloodInventory, "inventory_ID", "INV"
        )

        return BloodInventory.objects.create(
            **validated_data
        )

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

        validated_data["allocation_ID"] = generate_next_ID(
            Allocation, "allocation_ID", "AL"
        )

        return Allocation.objects.create(
            **validated_data
        )
        