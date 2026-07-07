from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Donor, DonorPhone
from .serializers import DonorSerializer, DonorPhoneSerializer

from rest_framework import status

from users.permissions import CanManageDonors

class DonorListAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get(self, request):

        donors = Donor.objects.all()

        serializer = DonorSerializer(donors, many=True)

        return Response(serializer.data)
    

    def post(self, request):

        serializer = DonorSerializer(data=request.data)

        if serializer.is_valid():

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class DonorDetailAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]
    
    def get(self, request, national_ID):

        donor = get_object_or_404(
            Donor,
            national_ID=national_ID
        )
        
        serializer = DonorSerializer(donor)
        
        return Response(serializer.data)

    
    def put(self, request, national_ID):

        donor = get_object_or_404(
            Donor,
            national_ID=national_ID
        )

        serializer = DonorSerializer(
            instance=donor,
            data=request.data
        )

        if serializer.is_valid():
            
            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_200_OK
            )
        
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )
    
    def patch(self, request, national_ID):

        donor = get_object_or_404(
            Donor,
            national_ID=national_ID
        )

        serializer = DonorSerializer(
            instance=donor,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():
            
            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_200_OK
            )
        
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )
    
    def delete(self, request, national_ID):

        donor = get_object_or_404(
            Donor,
            national_ID=national_ID
        )

        donor.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )
    

class DonorPhoneAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get(self, request, national_ID):

        donor = get_object_or_404(
            Donor,
            national_ID=national_ID
        )

        phones = DonorPhone.objects.filter(
            donor=donor
        )

        serializr = DonorSerializer(
            phones,
            many=True
        )

        return Response(serializr.data)
    
    def post(self, request, national_ID):

        donor = get_object_or_404(
            Donor,
            national_ID=national_ID
        )

        data=request.data.copy()

        data["donor"] = donor.national_ID

        serializer = DonorPhoneSerializer(
            data = data
        )

        if serializer.is_valid():

            serializer.save()

            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )
    

class DonorPhoneDetailAPIView(APIView):

    permission_classes = [
        CanManageDonors
    ]

    def get_object(self, request, national_ID, phone):

        return get_object_or_404(
            DonorPhone,
            donor_national_ID=national_ID,
            phone=phone
        )

    def get(self, request, national_ID, phone):

        donor_phone = self.get_object(
            national_ID, phone
        )

        serializer = DonorPhoneSerializer(
            donor_phone
        )

        return Response(serializer.data)
    
    def patch(self, request, national_ID, phone):

        donor_phone = self.get_object(
            national_ID, phone
        )

        serializer = DonorPhoneSerializer(
            instance=donor_phone,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():
            serializer.save()

            return Response(
                serializer.data,
                status = status.HTTP_200_OK
            )
        
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )
    
    def delete(self, request, national_ID, phone):

        donor_phone = self.get_object(
            national_ID, phone
        )

        donor_phone.delete()

        return Response(
            status = status.HTTP_204_NO_CONTENT
        )
