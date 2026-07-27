from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .models import Donation, Screening
from .serializers import DonationSerializer, ScreeningSerializer

from users.permissions import CanManageDonations, CanManageScreenings

from utils.db import fetch_all, fetch_one, execute, model_from_row


DNT_COLS = "donation_ID, units_donated, donation_date, national_ID"
SCR_COLS = "screening_result_ID, hb_level, bp, hepatitis_b, hepatitis_c, hiv, malaria, tested_on, tested_by, result, donation_ID"


class DonationListAPIView(APIView):

    permission_classes = [
        CanManageDonations
    ]

    def get(self, request):
        rows = fetch_all("SELECT %s FROM Donations" % DNT_COLS)
        donations = [model_from_row(Donation, row) for row in rows]
        serializer = DonationSerializer(donations, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = DonationSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                DonationSerializer(instance).data,
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
        row = fetch_one(
            "SELECT %s FROM Donations WHERE donation_ID = %%s" % DNT_COLS,
            [donation_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Donation matches the given query.")
        donation = model_from_row(Donation, row)
        serializer = DonationSerializer(donation)
        return Response(serializer.data)

    def put(self, request, donation_ID):
        row = fetch_one(
            "SELECT %s FROM Donations WHERE donation_ID = %%s" % DNT_COLS,
            [donation_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Donation matches the given query.")
        donation = model_from_row(Donation, row)
        serializer = DonationSerializer(instance=donation, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                DonationSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, donation_ID):
        row = fetch_one(
            "SELECT %s FROM Donations WHERE donation_ID = %%s" % DNT_COLS,
            [donation_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Donation matches the given query.")
        donation = model_from_row(Donation, row)
        serializer = DonationSerializer(instance=donation, data=request.data, partial=True)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                DonationSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, donation_ID):
        row = fetch_one(
            "SELECT donation_ID FROM Donations WHERE donation_ID = %s",
            [donation_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Donation matches the given query.")
        execute("DELETE FROM Donations WHERE donation_ID = %s", [donation_ID])
        return Response(status=status.HTTP_204_NO_CONTENT)


class ScreeningListAPIView(APIView):

    permission_classes = [
        CanManageScreenings
    ]

    def get(self, request):
        rows = fetch_all("SELECT %s FROM Screenings" % SCR_COLS)
        screenings = [model_from_row(Screening, row) for row in rows]
        serializer = ScreeningSerializer(screenings, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = ScreeningSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                ScreeningSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ScreeningRetrieveUpdateDestroyAPIView(APIView):

    permission_classes = [
        CanManageScreenings
    ]

    def get(self, request, screening_result_ID):
        row = fetch_one(
            "SELECT %s FROM Screenings WHERE screening_result_ID = %%s" % SCR_COLS,
            [screening_result_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Screening matches the given query.")
        screening = model_from_row(Screening, row)
        serializer = ScreeningSerializer(screening)
        return Response(serializer.data)

    def put(self, request, screening_result_ID):
        row = fetch_one(
            "SELECT %s FROM Screenings WHERE screening_result_ID = %%s" % SCR_COLS,
            [screening_result_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Screening matches the given query.")
        screening = model_from_row(Screening, row)
        serializer = ScreeningSerializer(instance=screening, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                ScreeningSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, screening_result_ID):
        row = fetch_one(
            "SELECT %s FROM Screenings WHERE screening_result_ID = %%s" % SCR_COLS,
            [screening_result_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Screening matches the given query.")
        screening = model_from_row(Screening, row)
        serializer = ScreeningSerializer(instance=screening, data=request.data, partial=True)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                ScreeningSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, screening_result_ID):
        row = fetch_one(
            "SELECT screening_result_ID FROM Screenings WHERE screening_result_ID = %s",
            [screening_result_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Screening matches the given query.")
        execute("DELETE FROM Screenings WHERE screening_result_ID = %s", [screening_result_ID])
        return Response(status=status.HTTP_204_NO_CONTENT)