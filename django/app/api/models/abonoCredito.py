from django.db import models

class AbonoCredito(models.Model):

    credito = models.ForeignKey('Credito', 
                                on_delete=models.CASCADE,
                                related_name="creditoAbono")
    cantidad = models.DecimalField(max_digits=8, decimal_places=2)

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True