from email.policy import default
from rest_framework import serializers
from api.models import Gasto, DetalleGasto


class GastoSerializer(serializers.ModelSerializer):
    total = serializers.DecimalField(max_digits=8, decimal_places=2, default=0)
    class Meta:
        model = Gasto
        fields = (
            'id',
            'descripcion',
            'total'
        )


class GastoRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = Gasto
        fields = (
            'descripcion',
        )





class DetalleGastoSerializer(serializers.ModelSerializer):
    descripcion = GastoSerializer()
    class Meta:
        model = DetalleGasto
        fields = (
            'id',
            'descripcion', 
            'cantidad',
            'creado',
        )
        depth=1


class DetalleGastoRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = DetalleGasto
        fields = (
            'descripcion',
            'cantidad',
            'creado',
        )