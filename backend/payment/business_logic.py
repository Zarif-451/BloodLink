from datetime import date
from .models import Payment
from utils.id_generator import generate_next_ID
from utils.db import insert_and_fetch
from django.conf import settings

PRICE_PER_BAG = settings.NEAR_EXPIRY_BLOOD_PRICE


def create_payment(allocation_row, selected_blood):
    """
    Creates a payment if any allocated blood bag is Near Expiry.
    """
    near_expiry_count = 0

    for inv in selected_blood:
        if inv["status"] == "Near Expiry":
            near_expiry_count += 1

    if near_expiry_count == 0:
        return None

    payment_amount = near_expiry_count * PRICE_PER_BAG

    payment = insert_and_fetch(
        "Payments",
        {
            "payment_ID": generate_next_ID("Payments", "payment_ID", "PAY"),
            "payment_amount": payment_amount,
            "payment_date": date.today(),
            "payment_status": "Pending",
            "allocation_ID": allocation_row["allocation_ID"],
        },
        model=Payment
    )

    return payment