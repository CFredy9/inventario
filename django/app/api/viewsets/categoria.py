from typing import Any
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
#from rest_framework.settings import api_settings

from django.db.models import Sum, Count

#from api.permission import IsStaff

from api.models import Categoria
from api.serializers import CategoriaSerializer, CategoriaRegistroSerializer


class CategoriaViewset(viewsets.ModelViewSet):
    queryset = Categoria.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("nombre",)
    search_fields = ("nombre",)
    ordering_fields = ("nombre",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return CategoriaSerializer
        else:
            return CategoriaRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]


    """@action(methods=["get"], detail=False)
    def total_cursos(self, request, *args, **kwargs):
        user = request.user
        queryset = Categoria.objects.filter(
            activo=True
            ).aggregate(
                total=Count(
                    'id'
                    ), 
                )
        return Response(queryset, status=status.HTTP_200_OK)"""