from django.db import models
from django.core.validators import MinValueValidator
from decimal import Decimal

PAYMENT_METHOD_CHOICES = [
    ("Cash", "Cash"),
    ("Card", "Card"),
    ("Mobile Banking", "Mobile Banking"),
    ("Bank Transfer", "Bank Transfer")
]

PAYMENT_STATUS_CHOICES = [
    ("Pending", "Pending"),
    ("Completed", "Completed"),
    ("Failed", "Failed")
]

class Payment(models.Model):
    payment_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    payment_amount = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(Decimal("0.00"))]
    )

    payment_date = models.DateField()

    payment_method = models.CharField(
        max_length=20,
        choices=PAYMENT_METHOD_CHOICES
    )

    payment_status = models.CharField(
        max_length=15,
        choices=PAYMENT_STATUS_CHOICES,
        default="Pending"
    )

    allocation = models.ForeignKey(
        "inventory.Allocation",
        on_delete=models.RESTRICT,
        db_column="allocation_ID",
        related_name="payments"
    )

    class Meta:
        db_table = "Payments"

