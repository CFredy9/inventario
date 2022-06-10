import json
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from django.core.files import File
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, filters, viewsets
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from rest_framework.decorators import action, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.settings import api_settings
from django.db import transaction

import datetime

from django.template.loader import render_to_string
import jwt
#import api.correo

from api.permission import IsAdmin, IsEmployee
from api.models import Usuario
from api.serializers import UsuarioSerializer, UsuarioRegistroSerializer

#from api.permission import IsStaff


class UserViewset(viewsets.ModelViewSet):
    queryset = User.objects.filter(is_active=True)

    filter_backends = (DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter)
    filter_fields = ("first_name",)
    search_fields = ("first_name",)
    ordering_fields = ("first_name",)

    def get_serializer_class(self):
        """Define serializer for API"""
        if self.action == 'list' or self.action == 'retrieve':
            return UsuarioSerializer
        else:
            return UsuarioRegistroSerializer

    def get_permissions(self):
        """" Define permisos para este recurso """
        if self.action == "token":
            permission_classes = [AllowAny]
        elif self.action == "create" or self.action == "destroy":
            permission_classes = [AllowAny]
        else:
            permission_classes = [AllowAny]
        return [permission() for permission in permission_classes]


    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        usuario = User.objects.get(email=request.data["email"])
        usuario.set_password(request.data["password"])
        usuario.save()
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def perform_create(self, serializer):
        serializer.save()

    def get_success_headers(self, data):
        try:
            return {'Location': str(data[api_settings.URL_FIELD_NAME])}
        except (TypeError, KeyError):
            return {}

    def update(self, request, pk):
        try:
            with transaction.atomic():
                user = request.data
                data = request.data
                #verify = UsuarioRegistroSerializer(data=data)
                #if verify.is_valid():

                usuario = User.objects.get(pk=pk)

                usuario.first_name = data.get('first_name')
                usuario.last_name = data.get('last_name')
                #usuario.email = data.get('email')
                usuario.phone = data.get('phone')
                #usuario.rol = data.get('rol')
                usuario.save()
                #else:
                #    return Response({"detail":str(verify.errors)}, status=status.HTTP_400_BAD_REQUEST)
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    """def update(self, request, pk):
        data = request.data
        try:
            avatar = data.get("avatar")
            data = json.loads(data["data"])
            user = request.user
            if user.username != data["username"]:
                try:
                    User.objects.get(username=data["username"])
                    return Response(
                        {"detail": "the chosen username in not available, please pick another"},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                except User.DoesNotExist:
                    pass
            user.username = data["username"]
            user.first_name = data["first_name"]
            user.last_name = data["last_name"]
            user.email = data["email"]
            perfil, created = Usuario.objects.get_or_create(user=user)
            if avatar is not None:
                perfil.avatar = File(avatar)
            profile = data.get("profile")
            if profile is not None:
                perfil.phone = profile.get("phone", perfil.phone)
                perfil.address = profile.get("address", perfil.address)
                perfil.gender = profile.get("gender", perfil.gender)
            user.save()
            perfil.save()
            serializer = UserReadSerializer(user)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except KeyError as e:
            return Response({"detail": "{} is a required field".format(str(e))}, status=status.HTTP_400_BAD_REQUEST)"""

    @action(methods=["get"], detail=False)
    def me(self, request, *args, **kwargs):
        user = request.user
        serializer = UsuarioSerializer(user)
        print(serializer.data)
        return Response(serializer.data, status=status.HTTP_200_OK)

    #@permission_classes([AllowAny])
    @action(methods=["post"], detail=False)
    def token(self, request, *args, **kwargs):
        data = request.data
        print(data)
        try:
            user = User.objects.get(email=data["email"])
            if user.check_password(data["password"]):
                token, created = Token.objects.get_or_create(user=user)
                serializer = UsuarioSerializer(user)
                return Response({"user": serializer.data, "token": token.key}, status=status.HTTP_200_OK)
            return Response({"detail": "Password does not match user password"}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({"detail": "User not found"}, status=status.HTTP_404_NOT_FOUND)
        except KeyError as e:
            return Response({"detail": "{} is a required field".format(str(e))}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=["post"], detail=False)
    def logout(self, request, *args, **kwargs):
        try:
            user = request.user
            print(user)
            token = Token.objects.get(user=request.user)
            token.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Token.DoesNotExist:
            return Response({"detail": "session not found"}, status=status.HTTP_404_NOT_FOUND)

    
    @action(methods=["patch"], detail=False)
    def update_contraseña(self, request, *args, **kwargs):
        data = request.data
        try:
            user = request.user
            data = request.data
            print(user)

            user = User.objects.get(username=user)
            #profile = Usuario.objects.get(user__username=user)

            user.set_password(data.get('password'))
            
            #if data.get('id') is None:
            #    profile.inicio_sesion = True

            user.save()
            #profile.save()

            return Response(status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    
    @action(methods=["post"], detail=False)
    def enviarCorreo(self, request, *args, **kwargs):
        try:
            data = request.data
            print(data)
            email = data[0]
            codigo = data[1]
            user = User.objects.get(email=email)
            serializer = UsuarioSerializer(user)
            print(serializer.data)
            usuario = serializer.data.get('first_name') + ' ' + serializer.data.get('last_name')
            #username = serializer.data.get('username')
            #email = data
            fecha = datetime.datetime.now()
            hoy = fecha.strftime('%Y-%m-%d %H:%M')
            encoded_jwt = jwt.encode({'usuario': usuario, 'email':email, 'fecha':hoy}, "secret", algorithm="HS256")
            print(encoded_jwt)
            ha = jwt.decode(encoded_jwt, "secret", algorithms=["HS256"])
            #{'some': 'payload'}
            print(ha)
            print("UNO")
            
            mailServer = smtplib.SMTP('smtp.gmail.com',587)
            mailServer.ehlo()
            mailServer.starttls()
            mailServer.ehlo()
            mailServer.login("tiendakairos7@gmail.com","yhbovuhhfjsgbkbp")


            # Construimos el mensaje simple
            mensaje = MIMEMultipart()
            mensaje['From']="tiendakairos7@gmail.com"
            mensaje['To']=email
            mensaje['Subject']="Solicitud de Cambio de Contraseña"

            content = render_to_string('./correo.html', {'codigo':codigo, 'usuario': usuario})
            #print("mensaje", mensaje)
            mensaje.attach(MIMEText(content, 'html'))
            
            # Envio del mensaje
            mailServer.sendmail("tiendakairos7@gmail.com",
                                email,
                                mensaje.as_string())
            return Response(status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=["get"], detail=False)
    def leer_codigo(self, request, *args, **kwargs):
        data = request.query_params
        codigo=""
        for x in data:
            codigo = codigo + data.get(x)
        token = jwt.decode(codigo, "secret", algorithms=["HS256"])
        return Response(token, status=status.HTTP_200_OK)

    @action(methods=["patch"], detail=False)
    def recuperacion_contraseña(self, request, *args, **kwargs):
        data = request.data
        try:
            data = request.data
            user = data.get('email')
            print('DATA', data)
            user = User.objects.get(email=user)
            user.set_password(data.get('password'))

            user.save()

            return Response(status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)