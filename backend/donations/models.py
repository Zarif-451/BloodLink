from django.db import models
from django.core.validators import MinValueValidator
from decimal import Decimal


class Donation(models.Model):

    donation_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    units_donated = models.IntegerField(
        validators=[MinValueValidator(1)]
    )

    donation_date = models.DateField()

    donor = models.ForeignKey(
        "donors.Donor",
        on_delete=models.RESTRICT,
        db_column="national_ID",
        related_name="donations"
    )

    class Meta:
        db_table = "Donations"



RESULT_CHOICES = [
    ("Eligible", "Eligible"),
    ("Ineligible", "Ineligible")
]


class Screening(models.Model):

    screening_result_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    hb_level = models.DecimalField(
        max_digits=4,
        decimal_places=2,
        validators=[MinValueValidator("0.00")]
    )

    bp = models.CharField(
        max_length=10
    )

    hepatitis_b = models.BooleanField()

    hepatitis_c = models.BooleanField()

    hiv = models.BooleanField()

    malaria = models.BooleanField()

    tested_on = models.DateField()

    tested_by = models.CharField(
        max_length=100
    )

    result = models.CharField(
        max_length=15,
        choices=RESULT_CHOICES
    )

    donation = models.OneToOneField(
        "donations.Donation",
        on_delete=models.RESTRICT,
        db_column="donation_ID",
        related_name="screening"
    )

    class Meta:
        db_table = "Screenings"