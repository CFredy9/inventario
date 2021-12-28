from django.db import models

class Producto(models.Model):


    nombre = models.CharField(max_length=100)
    unidadesFardo = models.IntegerField()
    categoria = models.ForeignKey('Categoria', 
                                on_delete=models.CASCADE,
                                related_name="categoria")

    activo = models.BooleanField(default=True)
    creado = models.DateTimeField(auto_now_add=True)
    modificado = models.DateTimeField(auto_now=True)

    def delete(self, *args):
        self.activo = False
        self.save()
        return True