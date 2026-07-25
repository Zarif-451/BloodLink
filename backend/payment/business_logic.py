from datetime import date

from .models import Payment
from utils.id_generator import generate_next_ID
from django.conf import settings

PRICE_PER_BAG = settings.NEAR_EXPIRY_BLOOD_PRICE

def create_payment(
    allocation,
    selected_blood
):
    """
    Creates a payment if any allocated blood bag
    is Near Expiry.
    """

    near_expiry_count = 0

    for inventory in selected_blood:

        if inventory.status == "Near Expiry":

            near_expiry_count += 1


    if near_expiry_count == 0:
        return None


    payment_amount = (
        near_expiry_count
        * PRICE_PER_BAG
    )


    payment = Payment.objects.create(

        payment_ID=generate_next_ID(
            Payment,
            "payment_ID",
            "PAY"
        ),

        payment_amount=payment_amount,

        payment_date=date.today(),

        payment_method=None,

        payment_status="Pending",

        allocation=allocation
    )

    return payment