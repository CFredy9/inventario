from django.db import models


class Gasto(models.Model):

    descripcion = models.CharField(max_length=100)

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True



class DetalleGasto(models.Model):

    descripcion = models.ForeignKey('Gasto', 
                                on_delete=models.CASCADE,
                                related_name="gasto")
    cantidad = models.DecimalField(max_digits=8, decimal_places=2)

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True