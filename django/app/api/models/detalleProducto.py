from django.db import models

class DetalleProducto(models.Model):

    producto = models.ForeignKey('Producto', 
                                on_delete=models.CASCADE,
                                related_name="producto")
    precio_costo = models.DecimalField(max_digits=8, decimal_places=2)
    precio_venta = models.DecimalField(max_digits=8, decimal_places=2)
    existencias = models.IntegerField(default=0)
    vencimiento = models.CharField(max_length=50, blank=True)
    almacen = models.ForeignKey('Ubicacion', 
                                on_delete=models.CASCADE,
                                related_name="ubi")
    estanteria = models.ForeignKey('Estanteria', 
                                on_delete=models.CASCADE,
                                related_name="estan")

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True