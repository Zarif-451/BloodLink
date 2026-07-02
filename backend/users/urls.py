from django.urls import path
from .views import UserListAPIView, UserDetailAPIView

urlpatterns = [

    path("", UserListAPIView.as_view(), name="user-list"),
    path(
    "<str:user_ID>/",
    UserDetailAPIView.as_view(),
    name="user-detail"),
]