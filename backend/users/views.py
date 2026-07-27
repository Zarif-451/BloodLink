from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .models import User, Report, UserPhone
from .serializers import UserSerializer, ReportSerializer, UserPhoneSerializer
from .business_logic import generate_report

from .permissions import (
    CanGenerateReports,
    CanViewNationwideReports,
    CanManageStaff,
)

from utils.db import fetch_all, fetch_one, execute, model_from_row


class UserListAPIView(APIView):

    permission_classes = [
        CanManageStaff
    ]

    def get(self, request):

        rows = fetch_all(
            "SELECT user_ID, full_name, email, password, role, status FROM Users"
        )

        users = [model_from_row(User, row) for row in rows]

        serializer = UserSerializer(
            users,
            many=True
        )

        return Response(serializer.data)

    def post(self, request):

        serializer = UserSerializer(
            data=request.data
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                UserSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class UserDetailAPIView(APIView):

    permission_classes = [
        CanManageStaff
    ]

    def get(self, request, user_ID):

        row = fetch_one(
            "SELECT user_ID, full_name, email, password, role, status FROM Users WHERE user_ID = %s",
            [user_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No User matches the given query.")

        user = model_from_row(User, row)

        serializer = UserSerializer(user)

        return Response(serializer.data)

    def put(self, request, user_ID):

        row = fetch_one(
            "SELECT user_ID, full_name, email, password, role, status FROM Users WHERE user_ID = %s",
            [user_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No User matches the given query.")

        user = model_from_row(User, row)

        serializer = UserSerializer(
            instance=user,
            data=request.data
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                UserSerializer(instance).data,
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def patch(self, request, user_ID):

        row = fetch_one(
            "SELECT user_ID, full_name, email, password, role, status FROM Users WHERE user_ID = %s",
            [user_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No User matches the given query.")

        user = model_from_row(User, row)

        serializer = UserSerializer(
            instance=user,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                UserSerializer(instance).data,
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, user_ID):

        row = fetch_one(
            "SELECT user_ID FROM Users WHERE user_ID = %s",
            [user_ID]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No User matches the given query.")

        execute(
            "DELETE FROM Users WHERE user_ID = %s",
            [user_ID]
        )

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )


class ReportListAPIView(APIView):

    permission_classes = [
        CanGenerateReports
    ]

    def get(self, request):
        rows = fetch_all("SELECT report_ID, generated_on, report_data, user_ID FROM Reports")
        reports = [model_from_row(Report, row) for row in rows]
        serializer = ReportSerializer(reports, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = ReportSerializer(data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                ReportSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class GenerateReportAPIView(APIView):

    permission_classes = [
        CanGenerateReports
    ]

    def post(self, request):

        try:

            report = generate_report(
                request.user
            )

            serializer = ReportSerializer(
                report
            )

            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )

        except ValueError as e:

            return Response(
                {
                    "error": str(e)
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        except Exception:

            return Response(
                {
                    "error": "An unexpected error occurred while generating the report."
                },
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class ReportRetrieveUpdateDestroyAPIView(APIView):

    permission_classes = [
        CanGenerateReports
    ]

    def get(self, request, report_ID):
        row = fetch_one(
            "SELECT report_ID, generated_on, report_data, user_ID FROM Reports WHERE report_ID = %s",
            [report_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Report matches the given query.")
        report = model_from_row(Report, row)
        serializer = ReportSerializer(report)
        return Response(serializer.data)

    def put(self, request, report_ID):
        row = fetch_one(
            "SELECT report_ID, generated_on, report_data, user_ID FROM Reports WHERE report_ID = %s",
            [report_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Report matches the given query.")
        report = model_from_row(Report, row)
        serializer = ReportSerializer(instance=report, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                ReportSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, report_ID):
        row = fetch_one(
            "SELECT report_ID, generated_on, report_data, user_ID FROM Reports WHERE report_ID = %s",
            [report_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Report matches the given query.")
        report = model_from_row(Report, row)
        serializer = ReportSerializer(instance=report, data=request.data, partial=True)
        if serializer.is_valid():
            instance = serializer.save()
            return Response(
                ReportSerializer(instance).data,
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, report_ID):
        row = fetch_one(
            "SELECT report_ID FROM Reports WHERE report_ID = %s",
            [report_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No Report matches the given query.")
        execute("DELETE FROM Reports WHERE report_ID = %s", [report_ID])
        return Response(status=status.HTTP_204_NO_CONTENT)


class NationwideReportAPIView(APIView):

    permission_classes = [
        CanViewNationwideReports
    ]

    def get(self, request):
        rows = fetch_all("SELECT report_ID, generated_on, report_data, user_ID FROM Reports")
        reports = [model_from_row(Report, row) for row in rows]
        serializer = ReportSerializer(reports, many=True)
        return Response(serializer.data)


class UserPhoneAPIView(APIView):

    permission_classes = [
        CanManageStaff
    ]

    def get(self, request, user_ID):

        row = fetch_one(
            "SELECT user_ID FROM Users WHERE user_ID = %s",
            [user_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No User matches the given query.")

        rows = fetch_all(
            "SELECT user_ID, phone FROM User_phone WHERE user_ID = %s",
            [user_ID]
        )

        phones = [model_from_row(UserPhone, row) for row in rows]

        serializer = UserPhoneSerializer(
            phones,
            many=True
        )

        return Response(serializer.data)

    def post(self, request, user_ID):

        row = fetch_one(
            "SELECT user_ID FROM Users WHERE user_ID = %s",
            [user_ID]
        )
        if row is None:
            from django.http import Http404
            raise Http404("No User matches the given query.")

        data = request.data.copy()

        data["user"] = user_ID

        serializer = UserPhoneSerializer(
            data=data
        )

        if serializer.is_valid():

            instance = serializer.save()

            return Response(
                UserPhoneSerializer(instance).data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class UserPhoneDetailAPIView(APIView):

    permission_classes = [
        CanManageStaff
    ]

    def get(self, request, user_ID, phone):

        row = fetch_one(
            "SELECT user_ID, phone FROM User_phone WHERE user_ID = %s AND phone = %s",
            [user_ID, phone]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No UserPhone matches the given query.")

        user_phone = model_from_row(UserPhone, row)

        serializer = UserPhoneSerializer(
            user_phone
        )

        return Response(serializer.data)

    def delete(self, request, user_ID, phone):

        row = fetch_one(
            "SELECT user_ID, phone FROM User_phone WHERE user_ID = %s AND phone = %s",
            [user_ID, phone]
        )

        if row is None:
            from django.http import Http404
            raise Http404("No UserPhone matches the given query.")

        execute(
            "DELETE FROM User_phone WHERE user_ID = %s AND phone = %s",
            [user_ID, phone]
        )

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )