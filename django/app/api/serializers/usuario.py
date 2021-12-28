from rest_framework import serializers
from django.contrib.auth.models import User
from api.models import Usuario

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'id',
            'first_name', 
            'last_name',
            'email',
            'phone', 
            'rol')

class UsuarioRegistroSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'first_name', 
            'last_name',
            'email',
            'username',
            'phone',
            'rol',
            'password'
        )