from django.urls import path
from .views import DonorListAPIView, DonorDetailAPIView
from .views import DonorPhoneAPIView, DonorPhoneDetailAPIView

urlpatterns = [
    path("", DonorListAPIView.as_view(), name="donor-list"),

    path(
    "<str:national_ID>/",
    DonorDetailAPIView.as_view(),
    name="donor-detail"
    ),

    path(
        "<str:national_ID>/phones/",
        DonorPhoneAPIView.as_view(),
        name="donor-phone-list"
    ),

    path(
        "<str:national_ID>/phones/<str:phone>/",
        DonorPhoneDetailAPIView.as_view(),
        name="donor-phone-detail"
    ),
]