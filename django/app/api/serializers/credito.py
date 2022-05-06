from rest_framework import serializers
from api.models import Credito


class CreditoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Credito
        fields = (
            'id',
            'nombreCredito',
            'total'
        )


class CreditoRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = Credito
        fields = (
            'nombreCredito',
        )

