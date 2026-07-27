from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from django.contrib.auth.hashers import check_password

from .serializers import LoginSerializer
from .jwt_utils import generate_access_token
from .authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated

from utils.db import fetch_one
from users.models import User


class LoginAPIView(APIView):

    def post(self, request):
        serializer = LoginSerializer(data=request.data)

        if not serializer.is_valid():
            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

        email = serializer.validated_data["email"]
        password = serializer.validated_data["password"]

        row = fetch_one(
            "SELECT user_ID, full_name, email, password, role, status FROM Users WHERE email = %s",
            [email]
        )

        if row is None:
            return Response(
                {"error": "Invalid email or password"},
                status=status.HTTP_401_UNAUTHORIZED
            )

        user = User(**row)

        if not check_password(password, user.password):
            return Response(
                {"error": "Invalid email or password"},
                status=status.HTTP_401_UNAUTHORIZED
            )

        if user.status != "Active":
            return Response(
                {"error": "Account is not active."},
                status=status.HTTP_403_FORBIDDEN
            )

        access_token = generate_access_token(user)

        return Response(
            {"access": access_token},
            status=status.HTTP_200_OK
        )


class ProfileAPIView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

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