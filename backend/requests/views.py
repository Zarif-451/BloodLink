from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Requester
from .serializers import RequesterSerializer
from rest_framework import status

from .models import Request
from .serializers import RequestSerializer

from users.permissions import CanManageBloodRequests

class RequesterListAPIView(APIView):

    permission_classes = [
        CanManageBloodRequests
    ]

    def get(self, request):

        requesters = Requester.objects.all()

        serializer = RequesterSerializer(
            requesters,
            many=True
        )

        return Response(serializer.data)
    

    def post(self, request):

        serializer = RequesterSerializer(
            data=request.data
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
    


class RequesterDetailAPIView(APIView):

    permission_classes = [
        CanManageBloodRequests
    ]
    
    def get(self, request, requester_ID):

        requester = get_object_or_404(
            Requester,
            requester_ID=requester_ID
        )
        
        serializer = RequesterSerializer(requester)
        
        return Response(serializer.data)
    

    def put(self, request, requester_ID):

        requester = get_object_or_404(
            Requester,
            requester_ID=requester_ID
        )

        serializer = RequesterSerializer(
            instance=requester,
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
    

    def patch(self, request, requester_ID):

        requester = get_object_or_404(
           Requester,
           requester_ID=requester_ID
        )

        serializer = RequesterSerializer(
            instance=requester,
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
    
    def delete(self, request, requester_ID):

        requester = get_object_or_404(
            Requester,
            requester_ID=requester_ID
        )

        requester.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )
    

class RequestListAPIView(APIView):

    def get(self, request):

        requests = Request.objects.all()

        serializer = RequestSerializer(
            requests,
            many=True
        )

        return Response(serializer.data)


    def post(self, request):

        serializer = RequestSerializer(
            data=request.data
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



class RequestDetailAPIView(APIView):

    def get(self, request, request_ID):

        blood_request = get_object_or_404(
            Request,
            request_ID=request_ID
        )

        serializer = RequestSerializer(blood_request)

        return Response(serializer.data)


    def put(self, request, request_ID):

        blood_request = get_object_or_404(
            Request,
            request_ID=request_ID
        )

        serializer = RequestSerializer(
            instance=blood_request,
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


    def patch(self, request, request_ID):

        blood_request = get_object_or_404(
            Request,
            request_ID=request_ID
        )

        serializer = RequestSerializer(
            instance=blood_request,
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


    def delete(self, request, request_ID):

        blood_request = get_object_or_404(
            Request,
            request_ID=request_ID
        )

        blood_request.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )