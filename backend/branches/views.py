from django.shortcuts import render, get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Branch, BranchPhone
from .serializers import BranchSerializer, BranchPhoneSerializer
from users.permissions import CanManageBranches

class BranchListAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]

    def get(self, request):

        branches = Branch.objects.all()

        serializer = BranchSerializer(
            branches,
            many=True
        )

        return Response(serializer.data)
    

    def post(self, request):

        serializer = BranchSerializer(
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
    

class BranchDetailAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]
    
    def get(self, request, branch_ID):

        branch = get_object_or_404(
            Branch,
            branch_ID=branch_ID
        )

        serializer = BranchSerializer(branch)
        
        return Response(serializer.data)
    
    def put(self, request, branch_ID):

        branch = get_object_or_404(
            Branch,
            branch_ID=branch_ID
        )

        serializer = BranchSerializer(
            instance=branch,
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
    
    def patch(self, request, branch_ID):

        branch = get_object_or_404(
            Branch,
            branch_ID=branch_ID
        )

        serializer = BranchSerializer(
            instance=branch,
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
    
    def delete(self, request, branch_ID):

        branch = get_object_or_404(
            Branch,
            branch_ID=branch_ID
        )

        branch.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )


class BranchPhoneListAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]


    def get(
        self,
        request,
        branch_ID
    ):

        branch = get_object_or_404(
            Branch,
            branch_ID=branch_ID
        )

        phones = BranchPhone.objects.filter(
            branch=branch
        )

        serializer = BranchPhoneSerializer(
            phones,
            many=True
        )

        return Response(serializer.data)


    def post(
        self,
        request,
        branch_ID
    ):

        branch = get_object_or_404(
            Branch,
            branch_ID=branch_ID
        )

        data = request.data.copy()

        data["branch"] = branch.branch_ID

        serializer = BranchPhoneSerializer(
            data=data
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
    

class BranchPhoneDetailAPIView(APIView):

    permission_classes = [
        CanManageBranches
    ]


    def get_object(
        self,
        branch_ID,
        phone
    ):

        return get_object_or_404(

            BranchPhone,

            branch__branch_ID=branch_ID,

            phone=phone
        )


    def get(
        self,
        request,
        branch_ID,
        phone
    ):

        branch_phone = self.get_object(
            branch_ID,
            phone
        )

        serializer = BranchPhoneSerializer(
            branch_phone
        )

        return Response(serializer.data)


    def delete(
        self,
        request,
        branch_ID,
        phone
    ):

        branch_phone = self.get_object(
            branch_ID,
            phone
        )

        branch_phone.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )