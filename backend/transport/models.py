from django.db import models

DESTINATION_TYPE_CHOICES = [
    ("Hospital", "Hospital"),
    ("Branch", "Branch"),
]

TRANSPORT_STATUS_CHOICES = [
    ("Pending", "Pending"),
    ("In Transit", "In Transit"),
    ("Delivered", "Delivered"),
    ("Cancelled", "Cancelled"),
]


class Transport(models.Model):

    transport_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    destination_type = models.CharField(
        max_length=15,
        choices=DESTINATION_TYPE_CHOICES
    )

    destination_name = models.CharField(
        max_length=100
    )

    transport_date = models.DateField()

    status = models.CharField(
        max_length=15,
        choices=TRANSPORT_STATUS_CHOICES,
        default="Pending"
    )

    branch = models.ForeignKey(
        "branches.Branch",
        on_delete=models.RESTRICT,
        db_column="branch_ID",
        related_name="transports"
    )

    class Meta:
        db_table = "Transports"