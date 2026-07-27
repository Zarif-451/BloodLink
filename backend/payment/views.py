from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.http import Http404

from .models import Payment
from .serializers import PaymentSerializer
from users.permissions import CanManagePayments
from utils.db import fetch_all, fetch_one, execute


PAY_COLS = "payment_ID, payment_amount, payment_date, payment_method, payment_status, allocation_ID"


class PaymentListAPIView(APIView):

    permission_classes = [CanManagePayments]

    def get(self, request):
        rows = fetch_all(f"SELECT {PAY_COLS} FROM Payments")
        payments = [Payment(**row) for row in rows]
        serializer = PaymentSerializer(payments, many=True)
        return Response(serializer.data)


class PaymentRetrieveUpdateDestroyAPIView(APIView):

    permission_classes = [CanManagePayments]

    def _get(self, payment_ID):
        row = fetch_one(
            f"SELECT {PAY_COLS} FROM Payments WHERE payment_ID = %s",
            [payment_ID]
        )
        if row is None:
            raise Http404("No Payment matches the given query.")
        return row

    def get(self, request, payment_ID):
        row = self._get(payment_ID)
        payment = Payment(**row)
        serializer = PaymentSerializer(payment)
        return Response(serializer.data)

    def put(self, request, payment_ID):
        row = self._get(payment_ID)
        payment = Payment(**row)
        serializer = PaymentSerializer(instance=payment, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                PaymentSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, payment_ID):
        row = self._get(payment_ID)
        payment = Payment(**row)
        serializer = PaymentSerializer(
            instance=payment, data=request.data, partial=True
        )
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                PaymentSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, payment_ID):
        self._get(payment_ID)
        execute("DELETE FROM Payments WHERE payment_ID = %s", [payment_ID])
        return Response(status=status.HTTP_204_NO_CONTENT)