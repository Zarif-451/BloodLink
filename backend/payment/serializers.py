from rest_framework import serializers
from .models import Payment
from utils.id_generator import generate_next_ID

class PaymentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Payment
        fields = "__all__"
        read_only_fields = [
            "payment_ID"
        ]

    def create(self, validated_data):

        validated_data["payment_ID"] = generate_next_ID(
            Payment, "payment_ID", "PAY"
        )

        return Payment.objects.create(
            **validated_data
        )