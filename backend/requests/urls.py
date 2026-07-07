from django.urls import path
from .views import RequesterListAPIView, RequesterDetailAPIView
from .views import RequestListAPIView, RequestDetailAPIView
from .views import RequesterPhoneListAPIView,RequesterPhoneDetailAPIView
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

    path(
        "<str:requester_ID>/phones/",
        RequesterPhoneListAPIView.as_view(),
        name="requester-phone-list"
    ),

    path(
        "<str:requester_ID>/phones/<str:phone>/",
        RequesterPhoneDetailAPIView.as_view(),
        name="requester-phone-detail"
    ),
]