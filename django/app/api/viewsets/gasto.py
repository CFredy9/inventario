from ast import Is
import datetime
from tokenize import Double
from typing import Any
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.db import transaction
#from rest_framework.settings import api_settings

from django.db.models import Sum, Count

#from api.permission import IsStaff
from api.permission import IsAdmin
from api.models import Gasto, DetalleGasto, Venta
from api.serializers import GastoSerializer, GastoRegistroSerializer, DetalleGastoSerializer, DetalleGastoRegistroSerializer


class GastoViewset(viewsets.ModelViewSet):
    queryset = Gasto.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("descripcion",)
    search_fields = ("descripcion",)
    ordering_fields = ("descripcion",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return GastoSerializer
        else:
            return GastoRegistroSerializer

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

        if(data['start'] != ''):
            first_date = datetime.datetime.strptime(data['start'], "%Y/%m/%d").date()
            last_date = datetime.datetime.strptime(data['end'], "%Y/%m/%d").date()

            first_date = first_date.strftime('%Y-%m-%d %H:%M:%S')
            last_date = last_date.strftime('%Y-%m-%d %H:%M:%S')

            queryset = Gasto.objects.filter(gasto__creado__range=(first_date, last_date), activo=True
            ).annotate(
                total=Sum('gasto__cantidad')
                )
        else:
            queryset = Gasto.objects.filter(activo=True)

        serializer = GastoSerializer(queryset, many=True)

        page = request.GET.get('page')

        
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            data = serializer.data
            return self.get_paginated_response(data)

        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(methods=["get"], detail=False)
    def totalBalance(self, request, *args, **kwargs):
        data = request.headers
        
        first_date = datetime.datetime.strptime(data['start'], "%Y/%m/%d").date()
        last_date = datetime.datetime.strptime(data['end'], "%Y/%m/%d").date()

        first_date = first_date.strftime('%Y-%m-%d %H:%M:%S')
        last_date = last_date.strftime('%Y-%m-%d %H:%M:%S')


        queryset = Gasto.objects.filter(gasto__creado__range=(first_date, last_date), activo=True
        ).aggregate(total=Sum('gasto__cantidad'))

        if(queryset['total'] == None):
            queryset['total'] = 0

        queryset['total'] = str(round(queryset['total'], 2))
        return Response(queryset, status=status.HTTP_200_OK)

    @action(methods=["get"], detail=False)
    def saldoBalance(self, request, *args, **kwargs):
        data = request.headers
        
        first_date = datetime.datetime.strptime(data['start'], "%Y/%m/%d").date()
        last_date = datetime.datetime.strptime(data['end'], "%Y/%m/%d").date()

        first_date = first_date.strftime('%Y-%m-%d %H:%M:%S')
        last_date = last_date.strftime('%Y-%m-%d %H:%M:%S')


        queryset = Gasto.objects.filter(gasto__creado__range=(first_date, last_date), activo=True
        ).aggregate(total=Sum('gasto__cantidad'))

        if(queryset['total'] == None):
            queryset['total'] = 0

        queryset2 = Venta.objects.filter(creado__range=(first_date, last_date), 
            activo=True
            ).aggregate(
                ganancia=Sum('ganancia'), 
                ) 
        if(queryset2['ganancia'] == None):
            queryset2['ganancia'] = 0

        queryset['total'] = float(queryset2['ganancia']) - float(queryset['total'])

        queryset['total'] = str(round(queryset['total'], 2))
        print(queryset['total'])

        return Response(queryset, status=status.HTTP_200_OK)


class DetalleGastoViewset(viewsets.ModelViewSet):
    queryset = DetalleGasto.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("cantidad",)
    search_fields = ("cantidad",)
    ordering_fields = ("cantidad",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return DetalleGastoSerializer
        else:
            return DetalleGastoRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        if self.action == "create" or self.action == "update" or self.action == "destroy":
            permission_classes = [IsAdmin]
        else:
            permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    def list(self, request, *args, **kwargs):
        data = request.headers
        id = data['Id']
        #id=1
        print(id)
        
        fecha = datetime.datetime.now()
        fechaN = str(fecha.year) + '-' + str(fecha.month) +  '-' + '1'
        fecha = datetime.datetime.strptime(fechaN, "%Y-%m-%d").date()
        print(fecha)

        queryset = DetalleGasto.objects.filter(descripcion__id=id, creado__gte=fecha, activo=True)
        print('Pasa')
        serializer = DetalleGastoSerializer(queryset, many=True)
        print('Pasa2')
        print(serializer.data)

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
                verify = DetalleGastoRegistroSerializer(data=data)
                if verify.is_valid():

                    descripcion = Gasto.objects.get(pk=data.get('descripcion'))
                    #print(request.data.get('profesion'))

                    detallegasto = DetalleGasto.objects.create(
                        descripcion=descripcion,
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
                verify = DetalleGastoRegistroSerializer(data=data)
                if verify.is_valid():

                    detallegasto = DetalleGasto.objects.get(pk=pk)
                    id_descripcion = data.get('descripcion')
                    descripcion = Gasto.objects.get(pk=id_descripcion)

                    detallegasto.descripcion = descripcion
                    detallegasto.cantidad = data.get('cantidad')
                    detallegasto.save()
                else:
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=["get"], detail=False)
    def total(self, request, *args, **kwargs):
        data = request.headers
        id = data['Id']
        
        fecha = datetime.datetime.now()
        fechaN = str(fecha.year) + '-' + str(fecha.month) +  '-' + '1'
        fecha = datetime.datetime.strptime(fechaN, "%Y-%m-%d").date()
        print(fecha)

        queryset = DetalleGasto.objects.filter(descripcion__id=id, creado__gte=fecha, activo=True
        ).aggregate(
            total=Sum('cantidad')
        )

        if(queryset['total'] == None):
            queryset['total'] = 0

        queryset['total'] = str(round(queryset['total'], 2))
        return Response(queryset, status=status.HTTP_200_OK)
