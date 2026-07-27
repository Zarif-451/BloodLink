from django.db import transaction
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.http import Http404

from inventory.models import Allocation
from .models import Transport
from .serializers import TransportSerializer
from .business_logic import assign_transport_to_allocations
from users.permissions import CanManageTransport
from utils.db import fetch_all, fetch_one, execute


TRN_COLS = "transport_ID, destination_type, destination_name, transport_date, status, branch_ID"


class TransportListAPIView(APIView):

    permission_classes = [CanManageTransport]

    def get(self, request):
        rows = fetch_all(f"SELECT {TRN_COLS} FROM Transports")
        transports = [Transport(**row) for row in rows]
        serializer = TransportSerializer(transports, many=True)
        return Response(serializer.data)

    def post(self, request):
        allocation_IDs = request.data.get("allocation_IDs", [])

        transport_data = request.data.copy()
        transport_data.pop("allocation_IDs", None)

        serializer = TransportSerializer(data=transport_data)
        serializer.is_valid(raise_exception=True)

        try:
            with transaction.atomic():
                transport_instance = serializer.save()
                transport_row = {
                    "transport_ID": transport_instance.transport_ID,
                    "destination_type": transport_instance.destination_type,
                    "destination_name": transport_instance.destination_name,
                    "transport_date": transport_instance.transport_date,
                    "status": transport_instance.status,
                    "branch_ID": transport_instance.branch_id,
                }
                assign_transport_to_allocations(transport_row, allocation_IDs)

            return Response(
                TransportSerializer(transport_instance).data,
                status=status.HTTP_201_CREATED
            )

        except ValueError as e:
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class TransportRetrieveUpdateDestroyAPIView(APIView):

    permission_classes = [CanManageTransport]

    def _get(self, transport_ID):
        row = fetch_one(
            f"SELECT {TRN_COLS} FROM Transports WHERE transport_ID = %s",
            [transport_ID]
        )
        if row is None:
            raise Http404("No Transport matches the given query.")
        return row

    def get(self, request, transport_ID):
        row = self._get(transport_ID)
        transport = Transport(**row)
        serializer = TransportSerializer(transport)
        return Response(serializer.data)

    def put(self, request, transport_ID):
        row = self._get(transport_ID)
        transport = Transport(**row)
        serializer = TransportSerializer(instance=transport, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                TransportSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, transport_ID):
        row = self._get(transport_ID)
        transport = Transport(**row)
        serializer = TransportSerializer(
            instance=transport, data=request.data, partial=True
        )
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                TransportSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, transport_ID):
        self._get(transport_ID)
        execute("DELETE FROM Transports WHERE transport_ID = %s", [transport_ID])
        return Response(status=status.HTTP_204_NO_CONTENT)