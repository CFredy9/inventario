from rest_framework import serializers
from api.models import Ubicacion


class UbicacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ubicacion
        fields = (
            'id', 
            'almacen'
            )


class UbicacionRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = Ubicacion
        fields = (
            'almacen',
        )