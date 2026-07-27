from rest_framework.views import APIView
from rest_framework.response import Response
from django.db import IntegrityError
from rest_framework import status
from django.http import Http404

from .models import Requester, Request, RequesterPhone
from .serializers import RequesterSerializer, RequestSerializer, RequesterPhoneSerializer
from users.permissions import CanManageBloodRequests
from utils.db import fetch_all, fetch_one, execute


RQR_COLS = "requester_ID, requester_type, name, street, area, city"
REQ_COLS = "request_ID, blood_group, quantity, urgency, request_date, status, requester_ID"
RQP_COLS = "requester_ID, phone"


class RequesterListAPIView(APIView):

    permission_classes = [CanManageBloodRequests]

    def get(self, request):
        rows = fetch_all(f"SELECT {RQR_COLS} FROM Requesters")
        requesters = [Requester(**row) for row in rows]
        serializer = RequesterSerializer(requesters, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = RequesterSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequesterSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class RequesterDetailAPIView(APIView):

    permission_classes = [CanManageBloodRequests]

    def _get(self, requester_ID):
        row = fetch_one(
            f"SELECT {RQR_COLS} FROM Requesters WHERE requester_ID = %s",
            [requester_ID]
        )
        if row is None:
            raise Http404("No Requester matches the given query.")
        return row

    def get(self, request, requester_ID):
        row = self._get(requester_ID)
        requester = Requester(**row)
        serializer = RequesterSerializer(requester)
        return Response(serializer.data)

    def put(self, request, requester_ID):
        row = self._get(requester_ID)
        requester = Requester(**row)
        serializer = RequesterSerializer(instance=requester, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequesterSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def patch(self, request, requester_ID):
        row = self._get(requester_ID)
        requester = Requester(**row)
        serializer = RequesterSerializer(
            instance=requester, data=request.data, partial=True
        )
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequesterSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, requester_ID):
        self._get(requester_ID)
        try:
            execute("DELETE FROM Requesters WHERE requester_ID = %s", [requester_ID])
        except IntegrityError:
            return Response(
                {"error": "Cannot delete. This requester has related records."},
                status=status.HTTP_409_CONFLICT
            )
        return Response(status=status.HTTP_204_NO_CONTENT)


class RequestListAPIView(APIView):

    permission_classes = [CanManageBloodRequests]

    def get_permissions(self):
        if self.request.method == "POST":
            return []
        return super().get_permissions()

    def get(self, request):
        rows = fetch_all(f"SELECT {REQ_COLS} FROM Requests")
        requests_list = [Request(**row) for row in rows]
        serializer = RequestSerializer(requests_list, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = RequestSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequestSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class RequestDetailAPIView(APIView):

    permission_classes = [CanManageBloodRequests]

    def _get(self, request_ID):
        row = fetch_one(
            f"SELECT {REQ_COLS} FROM Requests WHERE request_ID = %s",
            [request_ID]
        )
        if row is None:
            raise Http404("No Request matches the given query.")
        return row

    def get(self, request, request_ID):
        row = self._get(request_ID)
        blood_request = Request(**row)
        serializer = RequestSerializer(blood_request)
        return Response(serializer.data)

    def put(self, request, request_ID):
        row = self._get(request_ID)
        blood_request = Request(**row)
        serializer = RequestSerializer(instance=blood_request, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequestSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def patch(self, request, request_ID):
        row = self._get(request_ID)
        blood_request = Request(**row)
        serializer = RequestSerializer(
            instance=blood_request, data=request.data, partial=True
        )
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequestSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, request_ID):
        self._get(request_ID)
        try:
            execute("DELETE FROM Requests WHERE request_ID = %s", [request_ID])
        except IntegrityError:
            return Response(
                {"error": "Cannot delete. This request has related records."},
                status=status.HTTP_409_CONFLICT
            )
        return Response(status=status.HTTP_204_NO_CONTENT)


class RequesterPhoneListAPIView(APIView):

    permission_classes = [CanManageBloodRequests]

    def _get_requester(self, requester_ID):
        row = fetch_one(
            f"SELECT {RQR_COLS} FROM Requesters WHERE requester_ID = %s",
            [requester_ID]
        )
        if row is None:
            raise Http404("No Requester matches the given query.")
        return row

    def get(self, request, requester_ID):
        self._get_requester(requester_ID)
        rows = fetch_all(
            f"SELECT {RQP_COLS} FROM Requester_phone WHERE requester_ID = %s",
            [requester_ID]
        )
        phones = [RequesterPhone(**row) for row in rows]
        serializer = RequesterPhoneSerializer(phones, many=True)
        return Response(serializer.data)

    def post(self, request, requester_ID):
        self._get_requester(requester_ID)
        data = request.data.copy()
        data["requester"] = requester_ID
        serializer = RequesterPhoneSerializer(data=data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                RequesterPhoneSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class RequesterPhoneDetailAPIView(APIView):

    permission_classes = [CanManageBloodRequests]

    def _get(self, requester_ID, phone):
        row = fetch_one(
            f"SELECT {RQP_COLS} FROM Requester_phone WHERE requester_ID = %s AND phone = %s",
            [requester_ID, phone]
        )
        if row is None:
            raise Http404("No RequesterPhone matches the given query.")
        return row

    def get(self, request, requester_ID, phone):
        row = self._get(requester_ID, phone)
        requester_phone = RequesterPhone(**row)
        serializer = RequesterPhoneSerializer(requester_phone)
        return Response(serializer.data)

    def delete(self, request, requester_ID, phone):
        self._get(requester_ID, phone)
        execute(
            "DELETE FROM Requester_phone WHERE requester_ID = %s AND phone = %s",
            [requester_ID, phone]
        )
        return Response(status=status.HTTP_204_NO_CONTENT)