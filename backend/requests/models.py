from django.db import models
from django.core.validators import MinValueValidator

REQUESTER_TYPE_CHOICES = [
    ("Hospital", "Hospital"),
    ("Individual", "Individual")
]

class Requester(models.Model):
    requester_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    requester_type = models.CharField(
        max_length=15,
        choices=REQUESTER_TYPE_CHOICES
    )

    name = models.CharField(
        max_length=100
    )

    street = models.CharField(
        max_length=100
    )

    area = models.CharField(
        max_length=100
    )

    city = models.CharField(
        max_length=100
    )

    class Meta:
        db_table = "Requesters"


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

URGENCY_CHOICES = [
    ("Low", "Low"),
    ("Medium", "Medium"),
    ("High", "High"),
    ("Critical", "Critical")
]

STATUS_CHOICES = [
    ("Pending", "Pending"),
    ("Rejected", "Rejected"),
    ("Fulfilled","Fulfilled")
]

class Request(models.Model):
    request_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    blood_group = models.CharField(
        max_length=3,
        choices=BLOOD_GROUP_CHOICES
    )

    quantity = models.IntegerField(
        validators=[MinValueValidator(1)]
    )

    urgency = models.CharField(
        max_length=10,
        choices=URGENCY_CHOICES
    )

    status = models.CharField(
        max_length=15,
        choices=STATUS_CHOICES,
        default="Pending"
    )

    request_date = models.DateField()

    requester = models.ForeignKey(
        "requests.Requester",
        on_delete=models.RESTRICT,
        db_column="requester_ID",
        related_name="requests"
    )

    class Meta:
        db_table = "Requests"


class RequesterPhone(models.Model):

    pk = models.CompositePrimaryKey(
        "requester",
        "phone"
    )

    requester = models.ForeignKey(
        "requests.Requester",
        on_delete=models.CASCADE,
        db_column="requester_ID",
        related_name="phone_numbers"
    )

    phone = models.CharField(
        max_length=15
    )

    class Meta:
        db_table = "Requester_phone"