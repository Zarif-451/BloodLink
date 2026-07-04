from rest_framework.permissions import BasePermission

class IsSuperAdmin(BasePermission):
    def has_permission(self, request, view):
        return request.user.role == "SuperAdmin"
    

class CanManageBranches(BasePermission):
    def has_permission(self, request, view):
        return request.user.role == "SuperAdmin"
    

class CanViewNationwideReports(BasePermission):
    def has_permission(self, request, view):
        return request.user.role == "SuperAdmin"
    

class CanManageAdmins(BasePermission):
    def has_permission(self, request, view):
        return request.user.role == "SuperAdmin"
    

class CanGenerateReports(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin"
        ]
    

class CanManageStaff(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
        ]
    

class CanManageDonors(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    

class CanManageDonations(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    

class CanManageScreenings(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    

class CanManageInventory(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    

class CanManageBloodRequests(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    

class CanManageTransport(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    

class CanManagePayments(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [
            "SuperAdmin",
            "Admin",
            "Staff",
        ]
    