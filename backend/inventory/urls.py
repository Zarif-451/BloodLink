from django.urls import path

from .views import BloodInventoryListAPIView
from .views import BloodInventoryDetailAPIView
from .views import AllocationListAPIView
from .views import AllocationRetrieveUpdateDestroyAPIView

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

     path(
        "allocations/",
        AllocationListAPIView.as_view(),
        name="allocation-list-create"
    ),

    path(
        "allocations/<str:allocation_ID>/",
        AllocationRetrieveUpdateDestroyAPIView.as_view(),
        name="allocation-detail"
    ),

]