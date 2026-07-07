from django.urls import path
from .views import UserListAPIView, UserDetailAPIView
from .views import ReportListAPIView, ReportRetrieveUpdateDestroyAPIView
from .views import NationwideReportAPIView
from .views import UserPhoneAPIView, UserPhoneDetailAPIView
urlpatterns = [

    path("", UserListAPIView.as_view(), name="user-list"),

    path(
    "<str:user_ID>/",
    UserDetailAPIView.as_view(),
    name="user-detail"
    ),

    path(
    "reports/",
    ReportListAPIView.as_view(),
    name="report-list"
    ),
    
    path(
    "reports/<str:report_ID>/",
    ReportRetrieveUpdateDestroyAPIView.as_view(),
    name="report-detail"
    ),

    path(
    "reports/nationwide/",
    NationwideReportAPIView.as_view(),
    name="nationwide-report"
    ),

    path(
        "<str:user_ID>/phones/",
        UserPhoneAPIView.as_view(),
        name="user-phone-list"
    ),

    path(
        "<str:user_ID>/phones/<str:phone>/",
        UserPhoneDetailAPIView.as_view(),
        name="user-phone-detail"
    ),
]