from django.urls import path
from .views import DonorListAPIView, DonorDetailAPIView

urlpatterns = [
    path("", DonorListAPIView.as_view(), name="donor-list"),

    path(
    "<str:national_ID>/",
    DonorDetailAPIView.as_view(),
    name="donor-detail"
)
]