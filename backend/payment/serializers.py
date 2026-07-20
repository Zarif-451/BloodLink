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