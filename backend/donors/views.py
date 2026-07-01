from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Donor
from .serializers import DonorSerializer

class DonorListAPIView(APIView):

    def get(self, request):

        donors = Donor.objects.all()

        serializer = DonorSerializer(donors, many=True)

        return Response(serializer.data)

