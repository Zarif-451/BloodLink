from django.db import transaction

from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status

from inventory.models import Allocation

from .models import Transport
from .serializers import TransportSerializer
from .business_logic import assign_transport_to_allocations

from users.permissions import CanManageTransport


class TransportListAPIView(
    generics.ListCreateAPIView
):

    permission_classes = [
        CanManageTransport
    ]

    queryset = Transport.objects.all()

    serializer_class = TransportSerializer


    def create(
        self,
        request,
        *args,
        **kwargs
    ):

        allocation_IDs = request.data.get(
            "allocation_IDs",
            []
        )

        transport_data = request.data.copy()

        transport_data.pop(
            "allocation_IDs",
            None
        )

        serializer = self.get_serializer(
            data=transport_data
        )

        serializer.is_valid(
            raise_exception=True
        )

        try:

            with transaction.atomic():

                transport = serializer.save()

                assign_transport_to_allocations(
                    transport,
                    allocation_IDs
                )

            return Response(
                TransportSerializer(
                    transport
                ).data,
                status=status.HTTP_201_CREATED
            )

        except Allocation.DoesNotExist:

            return Response(
                {
                    "error": "Allocation not found."
                },
                status=status.HTTP_404_NOT_FOUND
            )

        except ValueError as e:

            return Response(
                {
                    "error": str(e)
                },
                status=status.HTTP_400_BAD_REQUEST
            )


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