from rest_framework.views import APIView
from rest_framework.response import Response
from django.db import IntegrityError

from .models import Donor, DonorPhone
from .serializers import DonorSerializer, DonorPhoneSerializer

from rest_framework import status

from users.permissions import CanManageDonors

from utils.db import fetch_all, fetch_one, execute, model_from_row


DONOR_COLS = "national_ID, full_name, date_of_birth, gender, blood_group, street, area, city, user_ID"


class DonorListAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get(self, request):

        rows = fetch_all("SELECT %s FROM Donors" % DONOR_COLS)
        donors = [model_from_row(Donor, row) for row in rows]
        serializer = DonorSerializer(donors, many=True)

        return Response(serializer.data)

    def post(self, request):

        serializer = DonorSerializer(data=request.data)

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                DonorSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class DonorDetailAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get(self, request, national_ID):

        row = fetch_one(
            "SELECT %s FROM Donors WHERE national_ID = %%s" % DONOR_COLS,
            [national_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No Donor matches the given query.")

        donor = model_from_row(Donor, row)
        serializer = DonorSerializer(donor)

        return Response(serializer.data)

    def put(self, request, national_ID):

        row = fetch_one(
            "SELECT %s FROM Donors WHERE national_ID = %%s" % DONOR_COLS,
            [national_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No Donor matches the given query.")

        donor = model_from_row(Donor, row)

        serializer = DonorSerializer(
            instance=donor,
            data=request.data
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                DonorSerializer(instance).data,
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def patch(self, request, national_ID):

        row = fetch_one(
            "SELECT %s FROM Donors WHERE national_ID = %%s" % DONOR_COLS,
            [national_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No Donor matches the given query.")

        donor = model_from_row(Donor, row)

        serializer = DonorSerializer(
            instance=donor,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                DonorSerializer(instance).data,
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, national_ID):

        row = fetch_one(
            "SELECT national_ID FROM Donors WHERE national_ID = %s",
            [national_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No Donor matches the given query.")

        try:

            execute(
                "DELETE FROM Donors WHERE national_ID = %s",
                [national_ID]
            )

        except IntegrityError:

            return Response(
                {
                    "error": "Cannot delete. This donor has related records."
                },
                status=status.HTTP_409_CONFLICT
            )

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )


class DonorPhoneAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get(self, request, national_ID):

        row = fetch_one(
            "SELECT national_ID FROM Donors WHERE national_ID = %s",
            [national_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Donor matches the given query.")

        rows = fetch_all(
            "SELECT national_ID, phone FROM Donor_phone WHERE national_ID = %s",
            [national_ID]
        )

        phones = [model_from_row(DonorPhone, row) for row in rows]

        serializer = DonorPhoneSerializer(
            phones,
            many=True
        )

        return Response(serializer.data)

    def post(self, request, national_ID):

        row = fetch_one(
            "SELECT national_ID FROM Donors WHERE national_ID = %s",
            [national_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Donor matches the given query.")

        data = request.data.copy()

        data["donor"] = national_ID

        serializer = DonorPhoneSerializer(
            data=data
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                DonorPhoneSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class DonorPhoneDetailAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get(self, request, national_ID, phone):

        row = fetch_one(
            "SELECT national_ID, phone FROM Donor_phone WHERE national_ID = %s AND phone = %s",
            [national_ID, phone]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No DonorPhone matches the given query.")

        donor_phone = model_from_row(DonorPhone, row)

        serializer = DonorPhoneSerializer(
            donor_phone
        )

        return Response(serializer.data)

    def delete(self, request, national_ID, phone):

        row = fetch_one(
            "SELECT national_ID, phone FROM Donor_phone WHERE national_ID = %s AND phone = %s",
            [national_ID, phone]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No DonorPhone matches the given query.")

        execute(
            "DELETE FROM Donor_phone WHERE national_ID = %s AND phone = %s",
            [national_ID, phone]
        )

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )