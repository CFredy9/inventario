import datetime
from decimal import Rounded
from unicodedata import decimal
from xmlrpc.client import DateTime
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
#from rest_framework.settings import api_settings
from django.db import transaction

from django.db.models import Sum, Count, Avg

#from api.permission import IsStaff

from api.models import Producto, Categoria, Venta
from api.serializers import ProductoSerializer, ProductoRegistroSerializer, VentaProductoSerializer


class ProductoViewset(viewsets.ModelViewSet):
    queryset = Producto.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("nombre",)
    search_fields = ("nombre",)
    ordering_fields = ("nombre",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return ProductoSerializer
        else:
            return ProductoRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    def list(self, request, *args, **kwargs):
        data = request.headers
        id = data['Id']
        print('Valor Categoria' + id)
        if id == '':
            print('Entra1')
            queryset = Producto.objects.filter(activo=True).annotate(existenciasT=Sum('producto__existencias'))
        else:
            print('Entra2')
            queryset = Producto.objects.filter(categoria__id=id, activo=True).annotate(existenciasT=Sum('producto__existencias'))
        #queryset = DetalleProducto.objects.filter(activo=True)
        serializer = ProductoSerializer(queryset, many=True)

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
                data = request.data

                #serializer = CatedraticoRegistroSerializer(data=request.data)
                verify = ProductoRegistroSerializer(data=data)
                if verify.is_valid():

                    categoria = Categoria.objects.get(pk=data.get('categoria'))
                    #print(request.data.get('profesion'))

                    producto = Producto.objects.create(
                        nombre=data.get('nombre'),
                        unidadesFardo=data.get('unidadesFardo'),
                        categoria=categoria,
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
                verify = ProductoRegistroSerializer(data=data)
                if verify.is_valid():

                    producto = Producto.objects.get(pk=pk)
                    id_categoria = data.get('categoria')
                    categoria = Categoria.objects.get(pk=id_categoria)

                    producto.nombre = data.get('nombre')
                    producto.unidadesFardo = data.get('unidadesFardo')
                    producto.categoria = categoria
                    producto.save()
                else:
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

class VentaProductoViewset(viewsets.ModelViewSet):

    serializer_class = VentaProductoSerializer
    queryset = Producto.objects.filter(activo=True)
    serializer = serializer_class(queryset)

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    def list (self, request, *args, **kwargs):
        #user = request.user
        data = request.headers

        
        
        first_date = datetime.datetime.strptime(data['start'], "%Y/%m/%d").date()
        last_date = datetime.datetime.strptime(data['end'], "%Y/%m/%d").date()

        first_date = first_date.strftime('%Y-%m-%d %H:%M:%S')
        last_date = last_date.strftime('%Y-%m-%d %H:%M:%S')

        print('Fecha Producto')
        print(first_date)
        print(last_date)
        #Filtración de calificacion de tareas del estudiante (Calificadas)
        queryset = Producto.objects.filter(producto__producto_venta__creado__range=(first_date, last_date), 
        activo=True).annotate(
            existenciasT=Sum('producto__producto_venta__fardos'),
            total_costo=Sum('producto__producto_venta__total_costo'),
            total_venta=Sum('producto__producto_venta__total_venta'),
            ganancia=Sum('producto__producto_venta__ganancia'), 
            )
        serializer = VentaProductoSerializer(queryset, many=True)

        page = request.GET.get('page')

        try: 
            page = self.paginate_queryset(queryset)
            print('page', page)
        except Exception as e:
            page = []
            data = page
            return Response({
                "status": status.HTTP_404_NOT_FOUND,
                "message": 'No more record.',
                "data" : data
                })

        if page is not None:
            serializer = self.get_serializer(page, many=True)
            data = serializer.data
            return self.get_paginated_response(data)

        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(methods=["get"], detail=False)
    def totales(self, request, *args, **kwargs):
        user = request.user
        data = request.headers
        
        first_date = datetime.datetime.strptime(data['start'], "%Y/%m/%d").date()
        last_date = datetime.datetime.strptime(data['end'], "%Y/%m/%d").date()

        first_date = first_date.strftime('%Y-%m-%d %H:%M:%S')
        last_date = last_date.strftime('%Y-%m-%d %H:%M:%S')

        print('Fecha Totales')
        print(first_date)
        print(last_date)

        queryset = Venta.objects.filter(creado__range=(first_date, last_date), 
            activo=True
            ).aggregate(
                total_costo=Sum('total_costo'),
                total_venta=Sum('total_venta'),
                ganancia=Sum('ganancia'), 
                ) 
        if(queryset['ganancia'] == None):
            queryset['total_costo'] = 0
            queryset['total_venta'] = 0
            queryset['ganancia'] = 0

        queryset['total_costo'] = str(round(queryset['total_costo'], 2))
        queryset['total_venta'] = str(round(queryset['total_venta'], 2))
        queryset['ganancia'] = str(round(queryset['ganancia'], 2))
        return Response(queryset, status=status.HTTP_200_OK)
