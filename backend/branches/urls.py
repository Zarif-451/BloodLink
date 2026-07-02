from django.urls import path
from .views import BranchListAPIView, BranchDetailAPIView


urlpatterns = [

    path("", BranchListAPIView.as_view(),
         name="branch-list"
    ),

    path(
    "<str:branch_ID>/",
    BranchDetailAPIView.as_view(),
    name="branch-detail"
)
]