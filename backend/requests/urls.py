from django.urls import path
from .views import RequesterListAPIView, RequesterDetailAPIView
from .views import RequestListAPIView, RequestDetailAPIView

urlpatterns = [
    
    path("requesters/", 
         RequesterListAPIView.as_view(),
         name="requester-list"),

    path(
    "requesters/<str:requester_ID>/",
    RequesterDetailAPIView.as_view(),
    name="requester-detail"),

    path("", 
         RequestListAPIView.as_view(),
         name="request-list"),

    path(
    "<str:request_ID>/",
    RequestDetailAPIView.as_view(),
    name="request-detail"),
]