from django.db import models


class Venta(models.Model):

    detalleproducto = models.ForeignKey('DetalleProducto', 
                                on_delete=models.CASCADE,
                                related_name="producto_venta")
    fardos = models.IntegerField(default=0)
    total_costo = models.DecimalField(max_digits=8, decimal_places=2)
    total_venta = models.DecimalField(max_digits=8, decimal_places=2)
    ganancia = models.DecimalField(max_digits=8, decimal_places=2)
    
    creado = models.DateTimeField(auto_now_add=True)
    activo = models.BooleanField(default=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True