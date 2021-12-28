from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework.authtoken.views import obtain_auth_token
from django.conf.urls import url
from api import viewsets


router = DefaultRouter()
router.register(r'categoria', viewsets.CategoriaViewset)
router.register(r'gasto', viewsets.GastoViewset)
router.register(r'usuario', viewsets.UserViewset)
router.register(r'ubicacion', viewsets.UbicacionViewset)
router.register(r'estanteria', viewsets.EstanteriaViewset)
router.register(r'producto', viewsets.ProductoViewset)
router.register(r'detalleproducto', viewsets.DetalleProductoViewset)
router.register(r'venta', viewsets.VentaViewset)
router.register(r'ventaproducto', viewsets.VentaProductoViewset)

urlpatterns = [
    path('api/', include(router.urls)),
    url(r"^api/token", obtain_auth_token, name="api-token"),
    path('api-auth/', include('rest_framework.urls')),
]