from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
#from rest_framework.settings import api_settings
from django.db import transaction

from django.db.models import Sum, Count

#from api.permission import IsStaff

from api.models import DetalleProducto, Producto, Ubicacion, Estanteria
from api.serializers import DetalleProductoSerializer, DetalleProductoRegistroSerializer


class DetalleProductoViewset(viewsets.ModelViewSet):
    queryset = DetalleProducto.objects.filter(activo=True)
    #permission_classes = (IsStaff,)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("existencias",)
    search_fields = ("existencias",)
    ordering_fields = ("existencias",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return DetalleProductoSerializer
        else:
            return DetalleProductoRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]

    def list(self, request, *args, **kwargs):
        data = request.headers
        id = data['Id']
        print(id)
        queryset = DetalleProducto.objects.filter(producto__id=id, activo=True)
        #queryset = DetalleProducto.objects.filter(activo=True)
        serializer = DetalleProductoSerializer(queryset, many=True)

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
                verify = DetalleProductoRegistroSerializer(data=data)
                if verify.is_valid():

                    producto = Producto.objects.get(pk=data.get('producto'))
                    #almacen = Ubicacion.objects.get(pk=data.get('almacen'))
                    #estanteria = Estanteria.objects.get(pk=data.get('estanteria'))
                    #print(request.data.get('profesion'))

                    detalleproducto = DetalleProducto.objects.create(
                        producto=producto,
                        precio_costo=data.get('precio_costo'),
                        precio_venta=data.get('precio_venta'),
                        existencias=data.get('existencias'),
                        vencimiento=data.get('vencimiento'),
                        #almacen=almacen,
                        #estanteria=estanteria
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
                verify = DetalleProductoRegistroSerializer(data=data)
                if verify.is_valid():

                    detalleproducto = DetalleProducto.objects.get(pk=pk)
                    id_producto = data.get('producto')
                    producto = Producto.objects.get(pk=id_producto)
                    #id_almacen = data.get('almacen')
                    #almacen = Ubicacion.objects.get(pk=id_almacen)
                    #id_estanteria = data.get('estanteria')
                    #estanteria = Estanteria.objects.get(pk=id_estanteria)

                    detalleproducto.producto = producto
                    detalleproducto.precio_costo = data.get('precio_costo')
                    detalleproducto.precio_venta = data.get('precio_venta')
                    detalleproducto.existencias = data.get('existencias')
                    detalleproducto.vencimiento = data.get('vencimiento')
                    #detalleproducto.almacen = almacen
                    #detalleproducto.estanteria = estanteria
                    detalleproducto.save()
                else:
                    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(verify.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)