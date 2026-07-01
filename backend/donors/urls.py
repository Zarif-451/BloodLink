from django.urls import path
from .views import DonorListAPIView

urlpatterns = [
    path("", DonorListAPIView.as_view(), name="donor-list")
]