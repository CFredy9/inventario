from typing import Any
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.db import transaction
#from rest_framework.settings import api_settings

from django.db.models import Sum, Count
import json
from django.core.files import File

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


    def list(self, request, *args, **kwargs):
        queryset = Categoria.objects.filter(activo=True)
        #queryset = DetalleProducto.objects.filter(activo=True)
        serializer = CategoriaSerializer(queryset, many=True)

        page = request.GET.get('page')

        
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            data = serializer.data
            return self.get_paginated_response(data)

        #print(serializer.data)

        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def create(self, request):
        try:
            with transaction.atomic():
                #user = request.data
                #imagen = data.get('imagen')
                data = request.data
                print(data)

                #serializer = CatedraticoRegistroSerializer(data=request.data)
                verify = CategoriaRegistroSerializer(data=data)
                if verify.is_valid():
                    
                    """if imagen is not None:
                        imagen = File(imagen)

                        categoria = Categoria.objects.create(
                            nombre=data.get('nombre'),
                            imagen=imagen
                        )
                    elif imagen is None:
                        categoria = Categoria.objects.create(
                            nombre=data.get('nombre'),
                        )"""
                    categoria = Categoria.objects.create(
                            nombre=data.get('nombre'),
                            imagen=data.get('imagen'),
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
                data = request.data

                print(data)

                #imagen = data.get("imagen")
                #data = json.loads(data["data"])

                #print('imagen', imagen)

                verify = CategoriaRegistroSerializer(data=data)
                #if verify.is_valid():

                categoria = Categoria.objects.get(pk=pk)

                """if categoria.imagen is None:
                    if imagen is not None:
                        categoria.imagen = File(imagen)
                elif categoria.imagen is not None:
                    if imagen is not None:
                        categoria.imagen.delete()
                        categoria.imagen = File(imagen)"""
                       

                categoria.nombre = data.get('nombre') 
                categoria.imagen = data.get('imagen')
                categoria.save()
                #else:
                #    return Response({"detail_serializer":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response( status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST) 
    
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