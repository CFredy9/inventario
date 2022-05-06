from rest_framework import serializers
from api.serializers import CreditoSerializer
from api.models import DetalleCredito

class DetalleCreditoSerializer(serializers.ModelSerializer):
    credito = CreditoSerializer()
    class Meta:
        model = DetalleCredito
        fields = (
            'id',
            'credito', 
            'cantidad',
            'creado',
        )
        depth=1

class DetalleCreditoRegistroSerializer(serializers.ModelSerializer):

    class Meta:
        model = DetalleCredito
        fields = (
            'credito',
            'cantidad',
            'creado',
        )