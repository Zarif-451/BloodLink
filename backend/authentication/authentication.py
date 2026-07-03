from rest_framework.authentication import BaseAuthentication

from rest_framework.exceptions import AuthenticationFailed

from users.models import User

from .jwt_utils import verify_access_token


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
        
        try:

            user = User.objects.get(
                user_ID=payload["user_ID"]
            )

        except User.DoesNotExist:

            raise AuthenticationFailed(
                "User not found."
            )
        
        return (user, token)