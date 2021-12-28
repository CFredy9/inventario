from rest_framework import serializers
from api.models import Estanteria
from api.serializers import UbicacionSerializer


class EstanteriaSerializer(serializers.ModelSerializer):
    almacen = UbicacionSerializer()
    class Meta:
        model = Estanteria
        fields = (
            'id',
            'almacen',
            'estanteria',
        )
        depth=1

class EstanteriaRegistroSerializer(serializers.ModelSerializer):

    #almacen = UbicacionRegistroSerializer()
    class Meta:
        model = Estanteria
        fields = (
            'almacen',
            'estanteria',
        )