import datetime
import decimal
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.db import transaction
from django.db.models import F, DecimalField
#from rest_framework.settings import api_settings

from django.db.models import Sum, Count

#from api.permission import IsStaff

from api.models import DetalleProducto, DetalleCredito
from api.serializers import DetalleProductoSerializer


class ReporteCapitalViewset(viewsets.ModelViewSet):
    queryset = DetalleProducto.objects.filter(activo=True)
    serializer_class = DetalleProductoSerializer
    #permission_classes = (IsStaff,)

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [AllowAny]
        return [permission() for permission in permission_classes]

    @action(methods=["get"], detail=False)
    def capital(self, request, *args, **kwargs):
        data = request.headers

        queryset = DetalleProducto.objects.filter(
            activo=True
            ).aggregate(
                total=Sum(F('precio_costo') * F('existencias'), output_field=DecimalField()),
                ) 

        queryset2 = DetalleCredito.objects.filter(
            activo=True
            ).aggregate(
                total_credito=Sum('cantidad'),
                ) 
                
        query = {
            'capital': str(round(queryset['total'] - queryset2['total_credito'], 2)),
            'total_costo': str(round(queryset['total'], 2)),
            'total_credito': str(round(queryset2['total_credito'], 2))
        }
        return Response(query, status=status.HTTP_200_OK)

    