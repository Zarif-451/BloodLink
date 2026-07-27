from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import IntegrityError
from .models import Branch, BranchPhone
from .serializers import BranchSerializer, BranchPhoneSerializer
from users.permissions import CanManageBranches

from utils.db import fetch_all, fetch_one, execute, model_from_row


BR_COLS = "branch_ID, branch_name, district, street, area, city, branch_status, user_ID"


class BranchListAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]

    def get(self, request):
        rows = fetch_all("SELECT %s FROM Branches" % BR_COLS)
        branches = [model_from_row(Branch, row) for row in rows]
        serializer = BranchSerializer(branches, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = BranchSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BranchSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class BranchDetailAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]

    def get(self, request, branch_ID):
        row = fetch_one(
            "SELECT %s FROM Branches WHERE branch_ID = %%s" % BR_COLS,
            [branch_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Branch matches the given query.")
        branch = model_from_row(Branch, row)
        serializer = BranchSerializer(branch)
        return Response(serializer.data)

    def put(self, request, branch_ID):
        row = fetch_one(
            "SELECT %s FROM Branches WHERE branch_ID = %%s" % BR_COLS,
            [branch_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Branch matches the given query.")
        branch = model_from_row(Branch, row)
        serializer = BranchSerializer(instance=branch, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BranchSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, branch_ID):
        row = fetch_one(
            "SELECT %s FROM Branches WHERE branch_ID = %%s" % BR_COLS,
            [branch_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Branch matches the given query.")
        branch = model_from_row(Branch, row)
        serializer = BranchSerializer(instance=branch, data=request.data, partial=True)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BranchSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, branch_ID):
        row = fetch_one(
            "SELECT branch_ID FROM Branches WHERE branch_ID = %s",
            [branch_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Branch matches the given query.")
        try:
            execute("DELETE FROM Branches WHERE branch_ID = %s", [branch_ID])
        except IntegrityError:
            return Response(
                {"error": "Cannot delete. This branch has related records."},
                status=status.HTTP_409_CONFLICT
            )
        return Response(status=status.HTTP_204_NO_CONTENT)


class BranchPhoneListAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]

    def get(self, request, branch_ID):
        row = fetch_one(
            "SELECT branch_ID FROM Branches WHERE branch_ID = %s",
            [branch_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Branch matches the given query.")

        rows = fetch_all(
            "SELECT branch_ID, phone FROM Branch_phone WHERE branch_ID = %s",
            [branch_ID]
        )
        phones = [model_from_row(BranchPhone, row) for row in rows]
        serializer = BranchPhoneSerializer(phones, many=True)
        return Response(serializer.data)

    def post(self, request, branch_ID):
        row = fetch_one(
            "SELECT branch_ID FROM Branches WHERE branch_ID = %s",
            [branch_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Branch matches the given query.")

        data = request.data.copy()
        data["branch"] = branch_ID
        serializer = BranchPhoneSerializer(data=data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                BranchPhoneSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class BranchPhoneDetailAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]

    def get(self, request, branch_ID, phone):
        row = fetch_one(
            "SELECT branch_ID, phone FROM Branch_phone WHERE branch_ID = %s AND phone = %s",
            [branch_ID, phone]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No BranchPhone matches the given query.")
        branch_phone = model_from_row(BranchPhone, row)
        serializer = BranchPhoneSerializer(branch_phone)
        return Response(serializer.data)

    def delete(self, request, branch_ID, phone):
        row = fetch_one(
            "SELECT branch_ID, phone FROM Branch_phone WHERE branch_ID = %s AND phone = %s",
            [branch_ID, phone]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No BranchPhone matches the given query.")
        execute(
            "DELETE FROM Branch_phone WHERE branch_ID = %s AND phone = %s",
            [branch_ID, phone]
        )
        return Response(status=status.HTTP_204_NO_CONTENT)