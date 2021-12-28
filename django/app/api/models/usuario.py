from django.db import models
from django.contrib.auth.models import User


class Usuario(models.Model):

    #user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    #rol = models.ForeignKey('Rol', on_delete=models.CASCADE, related_name="rol", null=True, blank=True) 
    #avatar = models.ImageField(upload_to='Avatar', null=True, blank=True)
    nombre = models.CharField(max_length=50, null=True, blank=True)
    apellido = models.CharField(max_length=50, null=True, blank=True)
    email = models.EmailField()
    contrasenia = models.CharField(max_length=50)
    telefono = models.CharField(max_length=15, null=True, blank=True)
    rol = models.CharField(max_length=25)  

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def __unicode__(self):
        return self.email

    def delete(self, *args):
        #user = self.user
        #user.is_active = False
        #user.save()
        self.active = False
        self.save()
        return True 