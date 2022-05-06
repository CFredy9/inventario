from django.db import models


class Credito(models.Model):

    nombreCredito = models.CharField(max_length=100)
    total = models.DecimalField(max_digits=8, decimal_places=2, default=0)

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True
