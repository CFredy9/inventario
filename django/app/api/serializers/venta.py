from rest_framework import serializers
from api.models import Venta
from api.serializers import DetalleProductoSerializer


class VentaSerializer(serializers.ModelSerializer):
    detalleproducto = DetalleProductoSerializer()
    class Meta:
        model = Venta
        fields = (
            'id',
            'detalleproducto',
            'fardos',
            'total_costo',
            'total_venta',
            'ganancia',
            'creado'
        )
        depth=2


class VentaRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = Venta
        fields = (
            'detalleproducto',
            'fardos',
            'total_costo',
            'total_venta',
            'ganancia'
        )