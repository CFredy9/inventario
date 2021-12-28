from rest_framework import serializers
from api.models import DetalleProducto
from api.serializers import ProductoSerializer, UbicacionSerializer, EstanteriaSerializer


class DetalleProductoSerializer(serializers.ModelSerializer):
    producto = ProductoSerializer()
    almacen = UbicacionSerializer()
    estanteria = EstanteriaSerializer()
    class Meta:
        model = DetalleProducto
        fields = (
            'id',
            'producto',
            'precio_costo',
            'precio_venta',
            'existencias',
            'vencimiento',
            'almacen',
            'estanteria',
        )
        depth=2

class DetalleProductoRegistroSerializer(serializers.ModelSerializer):

    #almacen = UbicacionRegistroSerializer()
    class Meta:
        model = DetalleProducto
        fields = (
            'producto',
            'precio_costo',
            'precio_venta',
            'existencias',
            'vencimiento',
            'almacen',
            'estanteria',
        )