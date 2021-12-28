from rest_framework import serializers
from api.models import Gasto


class GastoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Gasto
        fields = '__all__'


class GastoRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = Gasto
        fields = (
            'cantidad',
            'descripcion',
            'creado',
        )