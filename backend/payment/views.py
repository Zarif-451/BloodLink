from rest_framework import generics

from .models import Payment
from .serializers import PaymentSerializer

from users.permissions import CanManagePayments


class PaymentListAPIView(
    generics.ListAPIView
):

    permission_classes = [
        CanManagePayments
    ]

    queryset = Payment.objects.all()

    serializer_class = PaymentSerializer


class PaymentRetrieveUpdateDestroyAPIView(
    generics.RetrieveUpdateDestroyAPIView
):

    permission_classes = [
        CanManagePayments
    ]

    queryset = Payment.objects.all()

    serializer_class = PaymentSerializer

    lookup_field = "payment_ID"

    lookup_url_kwarg = "payment_ID"