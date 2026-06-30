from django.db import models

GENDER_CHOICES = [
    ("Male", "Male"),
    ("Female", "Female")
]

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

class Donor(models.Model):
    national_ID = models.CharField(
        max_length=17,
        primary_key=True
    )

    full_name = models.CharField(
        max_length=100
    )

    date_of_birth = models.DateField()

    gender = models.CharField(
        max_length=10,
        choices=GENDER_CHOICES
    )

    blood_group = models.CharField(
        max_length=3,
        choices=BLOOD_GROUP_CHOICES
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

    user = models.ForeignKey(
        "users.User",
        on_delete=models.RESTRICT,
        db_column="user_ID",
        related_name="donors"
    )

    class Meta:
        db_table = "Donors"


class DonorPhone(models.Model):

    pk = models.CompositePrimaryKey(
        "donor",
        "phone",
    )

    donor = models.ForeignKey(
        "donors.Donor",
        on_delete=models.CASCADE,
        db_column="national_ID",
        related_name="phone_numbers",
    )

    phone = models.CharField(
        max_length=15
    )

    class Meta:
        db_table = "Donor_phone"