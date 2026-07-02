from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import User
from .serializers import UserSerializer

from rest_framework import status


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
            user,
            user_ID=user_ID
        )

        user.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )