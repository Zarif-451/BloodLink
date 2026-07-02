from django.urls import path

from .views import BloodInventoryListAPIView
from .views import BloodInventoryDetailAPIView

urlpatterns = [

    path(
        "",
        BloodInventoryListAPIView.as_view(),
        name="inventory-list"
    ),

    path(
        "<str:inventory_ID>/",
        BloodInventoryDetailAPIView.as_view(),
        name="inventory-detail"
    ),

]