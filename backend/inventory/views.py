from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .models import BloodInventory
from .serializers import BloodInventorySerializer


class BloodInventoryListAPIView(APIView):

    def get(self, request):

        inventories = BloodInventory.objects.all()

        serializer = BloodInventorySerializer(
            inventories,
            many=True
        )

        return Response(serializer.data)


    def post(self, request):

        serializer = BloodInventorySerializer(
            data=request.data
        )

        if serializer.is_valid():

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class BloodInventoryDetailAPIView(APIView):

    def get(self, request, inventory_ID):

        inventory = get_object_or_404(
            BloodInventory,
            inventory_ID=inventory_ID
        )

        serializer = BloodInventorySerializer(inventory)

        return Response(serializer.data)


    def put(self, request, inventory_ID):

        inventory = get_object_or_404(
            BloodInventory,
            inventory_ID=inventory_ID
        )

        serializer = BloodInventorySerializer(
            instance=inventory,
            data=request.data
        )

        if serializer.is_valid():

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


    def patch(self, request, inventory_ID):

        inventory = get_object_or_404(
            BloodInventory,
            inventory_ID=inventory_ID
        )

        serializer = BloodInventorySerializer(
            instance=inventory,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


    def delete(self, request, inventory_ID):

        inventory = get_object_or_404(
            BloodInventory,
            inventory_ID=inventory_ID
        )

        inventory.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )