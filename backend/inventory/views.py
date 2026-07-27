from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import IntegrityError
from django.http import Http404

from .models import BloodInventory, Allocation
from .serializers import BloodInventorySerializer, AllocationSerializer

from users.permissions import CanManageInventory
from .business_logic import update_inventory_status
from .business_logic import create_allocation

from utils.db import fetch_all, fetch_one, execute


INV_COLS = "inventory_ID, blood_group, collection_date, status, branch_ID, request_ID, allocation_ID"
ALC_COLS = "allocation_ID, allocated_quantity, allocation_date, allocation_status, dispatched_time, received_time, transport_ID"


class BloodInventoryListAPIView(APIView):

    permission_classes = [CanManageInventory]

    def get(self, request):
        rows = fetch_all(f"SELECT {INV_COLS} FROM Blood_Inventory")
        inventories = [BloodInventory(**row) for row in rows]

        for inv_dict in rows:
            update_inventory_status(inv_dict)

        rows = fetch_all(f"SELECT {INV_COLS} FROM Blood_Inventory")
        inventories = [BloodInventory(**row) for row in rows]

        serializer = BloodInventorySerializer(inventories, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = BloodInventorySerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BloodInventorySerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class BloodInventoryDetailAPIView(APIView):

    permission_classes = [CanManageInventory]

    def _get(self, inventory_ID):
        row = fetch_one(
            f"SELECT {INV_COLS} FROM Blood_Inventory WHERE inventory_ID = %s",
            [inventory_ID]
        )
        if row is None:
            raise Http404("No BloodInventory matches the given query.")
        return row

    def get(self, request, inventory_ID):
        row = self._get(inventory_ID)
        update_inventory_status(row)
        row = self._get(inventory_ID)
        inventory = BloodInventory(**row)
        serializer = BloodInventorySerializer(inventory)
        return Response(serializer.data)

    def put(self, request, inventory_ID):
        row = self._get(inventory_ID)
        inventory = BloodInventory(**row)
        serializer = BloodInventorySerializer(instance=inventory, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BloodInventorySerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def patch(self, request, inventory_ID):
        row = self._get(inventory_ID)
        inventory = BloodInventory(**row)
        serializer = BloodInventorySerializer(
            instance=inventory, data=request.data, partial=True
        )
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BloodInventorySerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, inventory_ID):
        self._get(inventory_ID)
        try:
            execute("DELETE FROM Blood_Inventory WHERE inventory_ID = %s", [inventory_ID])
        except IntegrityError:
            return Response(
                {"error": "Cannot delete. This blood unit has related records."},
                status=status.HTTP_409_CONFLICT
            )
        return Response(status=status.HTTP_204_NO_CONTENT)


class AllocationListAPIView(APIView):

    permission_classes = [CanManageInventory]

    def get(self, request):
        rows = fetch_all(f"SELECT {ALC_COLS} FROM Allocations")
        allocations = [Allocation(**row) for row in rows]
        serializer = AllocationSerializer(allocations, many=True)
        return Response(serializer.data)

    def post(self, request):
        request_ID = request.data.get("request_ID")

        try:
            allocation = create_allocation(request_ID)
            serializer = AllocationSerializer(Allocation(**allocation))
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )

        except ValueError as e:
            if "not found" in str(e).lower():
                return Response(
                    {"error": "Request not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class AllocationRetrieveUpdateDestroyAPIView(APIView):

    permission_classes = [CanManageInventory]

    def _get(self, allocation_ID):
        row = fetch_one(
            f"SELECT {ALC_COLS} FROM Allocations WHERE allocation_ID = %s",
            [allocation_ID]
        )
        if row is None:
            raise Http404("No Allocation matches the given query.")
        return row

    def get(self, request, allocation_ID):
        row = self._get(allocation_ID)
        allocation = Allocation(**row)
        serializer = AllocationSerializer(allocation)
        return Response(serializer.data)

    def put(self, request, allocation_ID):
        row = self._get(allocation_ID)
        allocation = Allocation(**row)
        serializer = AllocationSerializer(instance=allocation, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                AllocationSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, allocation_ID):
        row = self._get(allocation_ID)
        allocation = Allocation(**row)
        serializer = AllocationSerializer(
            instance=allocation, data=request.data, partial=True
        )
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                AllocationSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, allocation_ID):
        self._get(allocation_ID)
        execute("DELETE FROM Allocations WHERE allocation_ID = %s", [allocation_ID])
        return Response(status=status.HTTP_204_NO_CONTENT)