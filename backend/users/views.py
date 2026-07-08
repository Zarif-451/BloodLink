from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import User, Report, UserPhone
from .serializers import UserSerializer, ReportSerializer, UserPhoneSerializer

from rest_framework import status, generics
from .permissions import CanGenerateReports, CanViewNationwideReports, CanManageStaff

class UserListAPIView(APIView):

    def get(self, request):

        users = User.objects.all()

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

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

class UserDetailAPIView(APIView):

    def get(self, request, user_ID):

        user = get_object_or_404(
            User,
            user_ID=user_ID
        )
        
        serializer = UserSerializer(user)
        
        return Response(serializer.data)
    

    def put(self, request, user_ID):

        user = get_object_or_404(
            User,
            user_ID=user_ID
        )

        serializer = UserSerializer(
            instance=user,
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
    

    def patch(self, request, user_ID):

        user = get_object_or_404(
            User,
            user_ID=user_ID
        )

        serializer = UserSerializer(
            instance=user,
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
    
    def delete(self, request, user_ID):

        user = get_object_or_404(
            User,
            user_ID=user_ID
        )

        user.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )
    

class ReportListAPIView(
    generics.ListCreateAPIView
):

    permission_classes = [
        CanGenerateReports
    ]

    queryset = Report.objects.all()

    serializer_class = ReportSerializer


class ReportRetrieveUpdateDestroyAPIView(
    generics.RetrieveUpdateDestroyAPIView
):

    permission_classes = [
        CanGenerateReports
    ]

    queryset = Report.objects.all()

    serializer_class = ReportSerializer

    lookup_field = "report_ID"

    lookup_url_kwarg = "report_ID"


class NationwideReportAPIView(generics.ListAPIView):

    permission_classes = [
        CanViewNationwideReports
    ]

    serializer_class = ReportSerializer

    queryset = Report.objects.all()



class UserPhoneAPIView(APIView):

    permission_classes = [
        CanManageStaff
    ]

    def get(self, request, user_ID):

        user = get_object_or_404(
            User,
            user_ID=user_ID
        )

        phones = UserPhone.objects.filter(
            user=user
        )

        serializer = UserPhoneSerializer(
            phones,
            many=True
        )

        return Response(serializer.data)
    
    def post(self, request, user_ID):

        user = get_object_or_404(
            User,
            user_ID=user_ID
        )

        data = request.data.copy()

        data["user"] = user.user_ID

        serializer = UserPhoneSerializer(
            data=data
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
    
class UserPhoneDetailAPIView(APIView):

    permission_classes = [
        CanManageStaff
    ]

    def get_object(self, user_ID, phone):

        return get_object_or_404(
            UserPhone,
            user__user_ID=user_ID,
            phone=phone
        )
    
    def get(self, request, user_ID, phone):

        user_phone = self.get_object(
            user_ID, phone
        )

        serializer = UserPhoneSerializer(
            user_phone
        )

        return Response(serializer.data)
    
    
    def delete(self, request, user_ID, phone):

        user_phone = self.get_object(
            user_ID, phone
        )

        user_phone.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )
