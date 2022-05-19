from email.policy import default
from rest_framework import serializers
from api.models import Producto
from api.serializers import CategoriaSerializer


class ProductoSerializer(serializers.ModelSerializer):
    categoria = CategoriaSerializer()
    existenciasT = serializers.IntegerField(default=0)
    class Meta:
        model = Producto
        fields = (
            'id',
            'nombre',
            'unidadesFardo',
            'existenciasT',
            'categoria',
        )
        depth=2

class ProductoVendidosSerializer(serializers.ModelSerializer):
    categoria = CategoriaSerializer()
    existenciasT = serializers.IntegerField(default=0)
    fardos = serializers.IntegerField(default=0)
    ganancia = serializers.DecimalField(max_digits=8, decimal_places=2, default=0)
    class Meta:
        model = Producto
        fields = (
            'id',
            'nombre',
            'unidadesFardo',
            'existenciasT',
            'categoria',
            'fardos',
            'ganancia'
        )
        depth=2

class VentaProductoSerializer(serializers.ModelSerializer):
    categoria = CategoriaSerializer()
    existenciasT = serializers.IntegerField(default=0)
    total_costo = serializers.DecimalField(max_digits=8, decimal_places=2)
    total_venta = serializers.DecimalField(max_digits=8, decimal_places=2)
    ganancia = serializers.DecimalField(max_digits=8, decimal_places=2)
    class Meta:
        model = Producto
        fields = (
            'id',
            'nombre',
            'unidadesFardo',
            'existenciasT',
            'total_costo',
            'total_venta',
            'ganancia',
            'categoria',
        )
        depth=2

class ProductoRegistroSerializer(serializers.ModelSerializer):

    #almacen = UbicacionRegistroSerializer()
    class Meta:
        model = Producto
        fields = (
            'nombre',
            'unidadesFardo',
            'categoria'
        )