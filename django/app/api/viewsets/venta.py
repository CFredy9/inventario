from xml.etree.ElementPath import prepare_parent
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
#from rest_framework.settings import api_settings
from django.db import transaction

from django.db.models import Sum, Count

#from api.permission import IsStaff
from api.permission import IsAdmin
from api.models import Venta, DetalleProducto
from api.serializers import VentaSerializer, VentaRegistroSerializer


class VentaViewset(viewsets.ModelViewSet):
    queryset = Venta.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("creado",)
    search_fields = ("creado",)
    ordering_fields = ("creado",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return VentaSerializer
        else:
            return VentaRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        if self.action == "create" or self.action == "update" or self.action == "destroy":
            permission_classes = [IsAdmin]
        else:
            permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    """def list(self, request, *args, **kwargs):
        data = request.query_params
        data2 = request.headers
        print(data2['Id'])
        id = data2['Id']
        queryset = Estanteria.objects.filter(almacen__id=id, activo=True)
        #queryset = Estanteria.objects.filter(activo=True)
        serializer = EstanteriaSerializer(queryset, many=True)

        page = request.GET.get('page')

        
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            data = serializer.data
            return self.get_paginated_response(data)

        return Response(serializer.data, status=status.HTTP_200_OK)"""
        

    def create(self, request):
        try:
            with transaction.atomic():
                #user = request.data
                data = request.data
                print(data)

                #serializer = CatedraticoRegistroSerializer(data=request.data)
                verify = VentaRegistroSerializer(data=data)
                if verify.is_valid():

                    detalleproducto = DetalleProducto.objects.get(pk=data.get('detalleproducto'))

                    venta = Venta.objects.create(
                        detalleproducto=detalleproducto,
                        fardos=data.get('fardos'),
                        total_costo=data.get('total_costo'),
                        total_venta=data.get('total_venta'),
                        ganancia=data.get('ganancia')
                    )
                    existenciasT = int(detalleproducto.existenciasT) - int(data.get('fardos'))

                    detalleproducto.existenciasT = existenciasT
                    detalleproducto.existencias = detalleproducto.existenciasT + detalleproducto.existenciasB
                    detalleproducto.save()
 
                else:
                    #print("Error en la verificación")
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    