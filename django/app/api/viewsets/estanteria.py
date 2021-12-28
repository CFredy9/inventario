from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
#from rest_framework.settings import api_settings
from django.db import transaction

from django.db.models import Sum, Count

#from api.permission import IsStaff

from api.models import Estanteria, Ubicacion
from api.serializers import EstanteriaSerializer, EstanteriaRegistroSerializer


class EstanteriaViewset(viewsets.ModelViewSet):
    queryset = Estanteria.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("estanteria",)
    search_fields = ("estanteria",)
    ordering_fields = ("estanteria",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return EstanteriaSerializer
        else:
            return EstanteriaRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    def list(self, request, *args, **kwargs):
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

        return Response(serializer.data, status=status.HTTP_200_OK)
        

    def create(self, request):
        try:
            with transaction.atomic():
                #user = request.data
                data = request.data

                #serializer = CatedraticoRegistroSerializer(data=request.data)
                verify = EstanteriaRegistroSerializer(data=data)
                if verify.is_valid():

                    almacen = Ubicacion.objects.get(pk=data.get('almacen'))
                    #print(request.data.get('profesion'))

                    estanteria = Estanteria.objects.create(
                        almacen=almacen,
                        estanteria=data.get('estanteria')
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
                user = request.data
                data = request.data
                verify = EstanteriaRegistroSerializer(data=data)
                if verify.is_valid():

                    estanteria = Estanteria.objects.get(pk=pk)
                    id_almacen = data.get('almacen')
                    almacen = Ubicacion.objects.get(pk=id_almacen)

                    estanteria.almacen = almacen
                    estanteria.estanteria = data.get('estanteria')
                    estanteria.save()
                else:
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    """@action(methods=["get"], detail=False)
    def total_grados(self, request, *args, **kwargs):
        user = request.user
        queryset = Grado.objects.filter(
            activo=True
            ).aggregate(
                total=Count(
                    'id'
                    ), 
                )
        return Response(queryset, status=status.HTTP_200_OK)"""