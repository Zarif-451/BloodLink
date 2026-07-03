from django.shortcuts import render, get_object_or_404

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from users.models import User
from .serializers import LoginSerializer

from .jwt_utils import generate_access_token

from django.contrib.auth.hashers import check_password


from .authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated


class LoginAPIView(APIView):

    def post(self, request):

        serializer = LoginSerializer(
            data=request.data
        )

        if not serializer.is_valid():

            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )
        

        email = serializer.validated_data["email"]
        password = serializer.validated_data["password"]


        try:

            user = User.objects.get(
                email=email
            )

        except User.DoesNotExist:

            return Response(
                {
                    "error" : "Invalid email or password"
                },
                status=status.HTTP_401_UNAUTHORIZED
            )
        
        if not check_password(
            password,
            user.password
        ):
            
            return Response(
                {
                    "error" : "Invalid email or password"
                },
                status=status.HTTP_401_UNAUTHORIZED
            )
        
        access_token = generate_access_token(user)

        return Response(
            {
                "access" : access_token
            },
            status=status.HTTP_200_OK
        )
    

class ProfileAPIView(APIView):

    authentication_classes = [JWTAuthentication]

    def get(self, request):

        return Response(
            {
                "user_ID": request.user.user_ID,
                "full_name": request.user.full_name,
                "email": request.user.email,
                "role": request.user.role,
                "status": request.user.status,
            }
        )