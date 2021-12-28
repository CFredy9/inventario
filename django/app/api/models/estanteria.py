from django.db import models


class Estanteria(models.Model):

    almacen = models.ForeignKey('Ubicacion', 
                                on_delete=models.CASCADE,
                                related_name="ubicacion")
    estanteria = models.CharField(max_length=50)

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True