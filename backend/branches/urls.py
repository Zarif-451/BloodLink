from django.urls import path
from .views import BranchListAPIView, BranchDetailAPIView
from .views import BranchPhoneListAPIView, BranchPhoneDetailAPIView

urlpatterns = [

    path("", BranchListAPIView.as_view(),
         name="branch-list"
    ),

    path(
    "<str:branch_ID>/",
    BranchDetailAPIView.as_view(),
    name="branch-detail"
),

path(
        "<str:branch_ID>/phones/",
        BranchPhoneListAPIView.as_view(),
        name="branch-phone-list"
    ),

    path(
        "<str:branch_ID>/phones/<str:phone>/",
        BranchPhoneDetailAPIView.as_view(),
        name="branch-phone-detail"
    ),

]