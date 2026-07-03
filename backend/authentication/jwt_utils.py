import jwt
from datetime import datetime, timedelta
from django.conf import settings

def generate_access_token(user):

    payload = {
        "user_ID" : user.user_ID,

        "role" : user.role,

        "exp" : datetime.utcnow() + timedelta(minutes=15),

        "iat" : datetime.utcnow(),
    }

    token = jwt.encode(
        payload,
        settings.SECRET_KEY,
        algorithm="HS256"
    )

    return token

def verify_access_token(token):

    try:

        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=["HS256"]
        )

        return payload
    
    except jwt.InvalidTokenError:

        return None
