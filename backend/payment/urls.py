from django.urls import path

from .views import (
    PaymentListAPIView,
    PaymentRetrieveUpdateDestroyAPIView,
)

urlpatterns = [

    path(
        "",
        PaymentListAPIView.as_view(),
        name="payment-list"
    ),

    path(
        "<str:payment_ID>/",
        PaymentRetrieveUpdateDestroyAPIView.as_view(),
        name="payment-detail"
    ),

]