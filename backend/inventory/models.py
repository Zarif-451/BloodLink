from django.db import models
from django.core.validators import MinValueValidator

BLOOD_GROUP_CHOICES = [
    ("A+", "A+"),
    ("A-", "A-"),
    ("B+", "B+"),
    ("B-", "B-"),
    ("AB+", "AB+"),
    ("AB-", "AB-"),
    ("O+", "O+"),
    ("O-", "O-"),
]

STATUS_CHOICES = [
    ("Available", "Available"),
    ("Unavailable", "Unavailable")
]


class BloodInventory(models.Model):

    inventory_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    blood_group = models.CharField(
        max_length=3,
        choices=BLOOD_GROUP_CHOICES
    )

    collection_date = models.DateField()

    status = models.CharField(
        max_length=15,
        choices=STATUS_CHOICES,
        default="Available"
    )

    branch = models.ForeignKey(
        "branches.Branch",
        on_delete=models.RESTRICT,
        db_column="branch_ID",
        related_name="inventories"
    )

    allocation = models.ForeignKey(
        "inventory.Allocation",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        db_column="allocation_ID",
        related_name="blood_units"
    )

    class Meta:
        db_table = "Blood_Inventory"



ALLOCATION_STATUS_CHOICES = [
    ("Pending", "Pending"),
    ("Allocated", "Allocated"),
    ("Cancelled", "Cancelled"),
]


class Allocation(models.Model):
    allocation_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    allocated_quantity = models.IntegerField(
        validators=[MinValueValidator(1)]
    )

    allocation_date = models.DateField()

    allocation_status = models.CharField(
        max_length=15,
        choices=ALLOCATION_STATUS_CHOICES,
        default="Pending"
    )

    transport = models.ForeignKey(
        "transport.Transport",
        on_delete=models.RESTRICT,
        db_column="transport_ID",
        related_name="allocations"
    )

    class Meta:
        db_table = "Allocations"