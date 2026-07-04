from rest_framework import generics

from .models import Transport
from .serializers import TransportSerializer

from users.permissions import CanManageTransport


class TransportListAPIView(
    generics.ListCreateAPIView
):

    permission_classes = [
        CanManageTransport
    ]

    queryset = Transport.objects.all()

    serializer_class = TransportSerializer


class TransportRetrieveUpdateDestroyAPIView(
    generics.RetrieveUpdateDestroyAPIView
):

    permission_classes = [
        CanManageTransport
    ]

    queryset = Transport.objects.all()

    serializer_class = TransportSerializer

    lookup_field = "transport_ID"

    lookup_url_kwarg = "transport_ID"