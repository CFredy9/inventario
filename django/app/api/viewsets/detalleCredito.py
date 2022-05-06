import datetime
import decimal
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.db import transaction
#from rest_framework.settings import api_settings

from django.db.models import Sum, Count

#from api.permission import IsStaff

from api.models import Credito, DetalleCredito
from api.serializers import DetalleCreditoSerializer, DetalleCreditoRegistroSerializer


class DetalleCreditoViewset(viewsets.ModelViewSet):
    queryset = DetalleCredito.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("credito",)
    search_fields = ("credito",)
    ordering_fields = ("credito",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return DetalleCreditoSerializer
        else:
            return DetalleCreditoRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [AllowAny]
        return [permission() for permission in permission_classes]

    def list(self, request, *args, **kwargs):
        data = request.headers
        id = data['Id']
        #id=1
        print(id)
        
        

        queryset = DetalleCredito.objects.filter(credito__id=id, activo=True)
        serializer = DetalleCreditoSerializer(queryset, many=True)

        page = request.GET.get('page')

        
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            data = serializer.data
            return self.get_paginated_response(data)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def create(self, request):
        try:
            with transaction.atomic():
                #user = request.data
                data = request.data
                print(data)

                #serializer = CatedraticoRegistroSerializer(data=request.data)
                verify = DetalleCreditoRegistroSerializer(data=data)
                if verify.is_valid():

                    nombreCredito = Credito.objects.get(pk=data.get('credito'))
                    #nombreCredito = Credito.objects.get(pk=1)

                    monto = nombreCredito.total
                    nombreCredito.total = monto + decimal.Decimal(data.get('cantidad'))
                    nombreCredito.save()

                    detallecredito = DetalleCredito.objects.create(
                        credito=nombreCredito,
                        cantidad=data.get('cantidad'),
                    )

                else:
                    #print("Error en la verificación")
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, pk):
        try:
            with transaction.atomic():
                #user = request.data
                data = request.data
                verify = DetalleCreditoRegistroSerializer(data=data)
                if verify.is_valid():

                    detallecredito = DetalleCredito.objects.get(pk=pk)
                    id_nombreCredito = data.get('credito')
                    #id_nombreCredito = 1
                    nombreCredito = Credito.objects.get(pk=id_nombreCredito)

                    monto = nombreCredito.total - detallecredito.cantidad
                    nombreCredito.total = monto + decimal.Decimal(data.get('cantidad'))
                    nombreCredito.save()

                    detallecredito.credito = nombreCredito
                    detallecredito.cantidad = data.get('cantidad')
                    detallecredito.save()
                else:
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    """@action(methods=["get"], detail=False)
    def total(self, request, *args, **kwargs):
        data = request.headers
        id = data['Id']
        
        fecha = datetime.datetime.now()
        fechaN = str(fecha.year) + '-' + str(fecha.month) +  '-' + '1'
        fecha = datetime.datetime.strptime(fechaN, "%Y-%m-%d").date()
        print(fecha)

        queryset = DetalleCredito.objects.filter(descripcion__id=id, creado__gte=fecha, activo=True
        ).aggregate(
            total=Sum('cantidad')
        )

        if(queryset['total'] == None):
            queryset['total'] = 0

        queryset['total'] = str(round(queryset['total'], 2))
        return Response(queryset, status=status.HTTP_200_OK)"""