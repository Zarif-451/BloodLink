from django.urls import path

from .views import (
    DonationListAPIView,
    DonationDetailAPIView,
)

urlpatterns = [

    path(
        "",
        DonationListAPIView.as_view(),
        name="donation-list"
    ),

    path(
        "<str:donation_ID>/",
        DonationDetailAPIView.as_view(),
        name="donation-detail"
    ),

]