from rest_framework import serializers
from api.models import Categoria


class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = (
            'id',
            'nombre'
            )


class CategoriaRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = Categoria
        fields = (
            'nombre',
        )