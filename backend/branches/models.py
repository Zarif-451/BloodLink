from django.db import models

BRANCH_STATUS_CHOICES = [
    ("Active", "Active"),
    ("Inactive", "Inactive"),
]


class Branch(models.Model):

    branch_ID = models.CharField(
        max_length=20,
        primary_key=True
    )

    branch_name = models.CharField(
        max_length=100
    )

    district = models.CharField(
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

    branch_status = models.CharField(
        max_length=15,
        choices=BRANCH_STATUS_CHOICES,
        default="Active"
    )

    user = models.ForeignKey(
        "users.User",
        on_delete=models.RESTRICT,
        db_column="user_ID",
        related_name="branches"
    )

    class Meta:
        db_table = "Branches"


class BranchPhone(models.Model):

    pk = models.CompositePrimaryKey(
        "branch",
        "phone"
    )

    branch = models.ForeignKey(
        "branches.Branch",
        on_delete=models.CASCADE,
        db_column="branch_ID",
        related_name="phone_numbers"
    )

    phone = models.CharField(
        max_length=15
    )

    class Meta:
        db_table = "Branch_phone"