from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .models import Donation
from .serializers import DonationSerializer, ScreeningSerializer

from .models import Screening
from rest_framework import generics
from users.permissions import CanManageDonations, CanManageScreenings


class DonationListAPIView(APIView):

    permission_classes = [
        CanManageDonations
    ]

    def get(self, request):

        donations = Donation.objects.all()

        serializer = DonationSerializer(
            donations,
            many=True
        )

        return Response(serializer.data)


    def post(self, request):

        serializer = DonationSerializer(
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


class DonationDetailAPIView(APIView):

    permission_classes = [
        CanManageDonations
    ]

    def get(self, request, donation_ID):

        donation = get_object_or_404(
            Donation,
            donation_ID=donation_ID
        )

        serializer = DonationSerializer(donation)

        return Response(serializer.data)


    def put(self, request, donation_ID):

        donation = get_object_or_404(
            Donation,
            donation_ID=donation_ID
        )

        serializer = DonationSerializer(
            instance=donation,
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


    def patch(self, request, donation_ID):

        donation = get_object_or_404(
            Donation,
            donation_ID=donation_ID
        )

        serializer = DonationSerializer(
            instance=donation,
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


    def delete(self, request, donation_ID):

        donation = get_object_or_404(
            Donation,
            donation_ID=donation_ID
        )

        donation.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )
    

class ScreeningListAPIView(
    generics.ListCreateAPIView
):
    permission_classes = [
        CanManageScreenings
    ]

    queryset = Screening.objects.all()

    serializer_class = ScreeningSerializer
    

class ScreeningRetrieveUpdateDestroyAPIView(
    generics.RetrieveUpdateDestroyAPIView
):
    permission_classes = [
        CanManageScreenings
    ]
    
    queryset = Screening.objects.all()

    serializer_class = ScreeningSerializer

    lookup_field = "screening_result_ID"
    lookup_url_kwarg = "screening_result_ID"