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

    payment_required = False

    for inventory in selected_blood:

        if inventory.status == "Near Expiry":

            payment_required = True
            break


    if not payment_required:
        return None


    payment_amount = (
        allocation.allocated_quantity
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