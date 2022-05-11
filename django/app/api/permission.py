from rest_framework.permissions import BasePermission

class IsAdmin(BasePermission):
    def has_permission(self, request, view):
        if request.user:
            if request.user.rol == "Administrador":
                return True
            else:
                return False
        else:
            return False

class IsEmployee(BasePermission):
    def has_permission(self, request, view):
        if request.user:
            if request.user.rol == "Empleado":
                return True
            else:
                return False
        else:
            return False

"""class IsStaff(BasePermission):
    def has_permission(self, request, view):
        if request.user:
            if request.user.is_staff == 1:
                return True
            else:
                return False
        else:
            return False"""