from rest_framework.authentication import BaseAuthentication

from rest_framework.exceptions import AuthenticationFailed

from users.models import User

from .jwt_utils import verify_access_token

from utils.db import fetch_one


class JWTAuthentication(BaseAuthentication):

    def authenticate(self, request):
        auth_header = request.headers.get(
            "Authorization"
        )

        if not auth_header:

            return None

        parts = auth_header.split()

        if len(parts) != 2 or parts[0] != "Bearer":

            raise AuthenticationFailed(
                "Invalid Authorization header."
            )

        token = parts[1]

        payload = verify_access_token(token)

        if payload is None:

            raise AuthenticationFailed(
                "Invalid or expired token"
            )

        row = fetch_one(
            "SELECT user_ID, full_name, email, password, role, status FROM Users WHERE user_ID = %s",
            [payload["user_ID"]]
        )

        if row is None:

            raise AuthenticationFailed(
                "User not found."
            )

        user = User(
            user_ID=row["user_ID"],
            full_name=row["full_name"],
            email=row["email"],
            password=row["password"],
            role=row["role"],
            status=row["status"],
        )

        return (user, token)