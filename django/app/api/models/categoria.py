from django.db import models


class Categoria(models.Model):

    nombre = models.CharField(max_length=100)
    imagen = models.CharField(max_length=200, null=True, blank=True)
    #imagen = models.ImageField(upload_to='Image_Categoria', null=True, blank=True)

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True