from django.db import models

ROLE_CHOICES = [
    ("SuperAdmin", "SuperAdmin"),
    ("Admin", "Admin"),
    ("Staff", "Staff"),
]

STATUS_CHOICES = [
    ("Active", "Active"),
    ("Inactive", "Inactive"),
    ("Suspended", "Suspended")
]


class User(models.Model):
    user_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    full_name = models.CharField(
        max_length=100
    )

    email = models.EmailField(
        max_length=100,
        unique=True
    )

    password = models.CharField(
        max_length=255
    )

    role = models.CharField(
        max_length=15,
        choices=ROLE_CHOICES
    )

    status = models.CharField(
        max_length=15,
        choices=STATUS_CHOICES,
        default="Active"
    )
    
    class Meta:
        db_table = "Users"


class UserPhone(models.Model):

    pk = models.CompositePrimaryKey(
        "user",
        "phone"
    )

    user = models.ForeignKey(
        "users.User",
        on_delete=models.CASCADE,
        db_column="user_ID",
        related_name="phone_numbers"
    )

    phone = models.CharField(
        max_length=15
    )

    class Meta:
        db_table = "User_phone"