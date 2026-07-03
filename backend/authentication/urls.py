from django.urls import path
from .views import LoginAPIView, ProfileAPIView

urlpatterns = [
    path(
        "login/",
        LoginAPIView.as_view(),
        name="login"
    ),

     path(
        "profile/",
        ProfileAPIView.as_view(),
        name="profile"
    ),
]