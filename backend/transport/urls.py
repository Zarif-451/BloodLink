from django.urls import path

from .views import (
    TransportListAPIView,
    TransportRetrieveUpdateDestroyAPIView,
)

urlpatterns = [

    path(
        "",
        TransportListAPIView.as_view(),
        name="transport-list"
    ),

    path(
        "<str:transport_ID>/",
        TransportRetrieveUpdateDestroyAPIView.as_view(),
        name="transport-detail"
    ),

]