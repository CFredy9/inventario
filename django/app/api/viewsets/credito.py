import datetime
from typing import Any
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.db import transaction
from django.db.models import F
#from rest_framework.settings import api_settings

from django.db.models import Sum, Count

#from api.permission import IsStaff
from api.permission import IsAdmin
from api.models import Credito
from api.serializers import CreditoSerializer, CreditoRegistroSerializer


class CreditoViewset(viewsets.ModelViewSet):
    queryset = Credito.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("nombreCredito",)
    search_fields = ("nombreCredito",)
    ordering_fields = ("nombreCredito",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return CreditoSerializer
        else:
            return CreditoRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        if self.action == "create" or self.action == "update" or self.action == "destroy":
            permission_classes = [IsAdmin]
        else:
            permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    def list(self, request, *args, **kwargs):
        data = request.headers
        print(data)

        queryset = Credito.objects.filter(activo=True)

        serializer = CreditoSerializer(queryset, many=True)

        page = request.GET.get('page')

        
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            data = serializer.data
            return self.get_paginated_response(data)

        return Response(serializer.data, status=status.HTTP_200_OK)

    