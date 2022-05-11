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
from api.permission import IsAdmin
from api.models import Credito, AbonoCredito
from api.serializers import AbonoCreditoSerializer, AbonoCreditoRegistroSerializer


class AbonoCreditoViewset(viewsets.ModelViewSet):
    queryset = AbonoCredito.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("credito",)
    search_fields = ("credito",)
    ordering_fields = ("credito",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return AbonoCreditoSerializer
        else:
            return AbonoCreditoRegistroSerializer

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
        
        

        queryset = AbonoCredito.objects.filter(credito__id=id, activo=True)
        serializer = AbonoCreditoSerializer(queryset, many=True)

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
                verify = AbonoCreditoRegistroSerializer(data=data)
                if verify.is_valid():

                    nombreCredito = Credito.objects.get(pk=data.get('credito'))
                    #nombreCredito = Credito.objects.get(pk=1)
                    
                    monto = nombreCredito.total
                    nombreCredito.total = monto - decimal.Decimal(data.get('cantidad'))
                    nombreCredito.save()

                    abonocredito = AbonoCredito.objects.create(
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
                verify = AbonoCreditoRegistroSerializer(data=data)
                if verify.is_valid():

                    abonocredito = AbonoCredito.objects.get(pk=pk)
                    id_nombreCredito = data.get('credito')
                    #id_nombreCredito = 1
                    nombreCredito = Credito.objects.get(pk=id_nombreCredito)

                    monto = nombreCredito.total + abonocredito.cantidad
                    nombreCredito.total = monto - decimal.Decimal(data.get('cantidad'))
                    nombreCredito.save()

                    abonocredito.credito = nombreCredito
                    abonocredito.cantidad = data.get('cantidad')
                    abonocredito.save()
                else:
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)