from django.urls import path

from .views import (
    DonationListAPIView,
    DonationDetailAPIView,
    ScreeningListAPIView,
    ScreeningRetrieveUpdateDestroyAPIView
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

    path(
        "screenings/",
        ScreeningListAPIView.as_view(),
        name="screening-list-create"
    ),

    path(
        "screenings/<str:screening_result_ID>/",
        ScreeningRetrieveUpdateDestroyAPIView.as_view(),
        name="screening-detail"
    ),

]