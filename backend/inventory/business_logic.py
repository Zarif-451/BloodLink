from datetime import date
from requests.models import Request
from .models import BloodInventory, Allocation
from utils.id_generator import generate_next_ID
from payment.business_logic import create_payment

def update_inventory_status(inventory):
     """
    Updates the inventory status based on collection_date.

    Rules:
    - Allocated blood remains Allocated.
    - 0-34 days  -> Available
    - 35-41 days -> Near Expiry
    - 42+ days   -> Expired
    """
     
     if inventory.status == "Allocated":
          return
     
     days_stored = (date.today() - inventory.collection_date).days


     if days_stored >= 42:
          new_status = "Expired"

     elif days_stored >= 35:
          new_status = "Near Expiry"

     else:
          new_status = "Available"



     if inventory.status != new_status:
          inventory.status = new_status
          inventory.save(update_fields=["status"])



def create_allocation(request_ID):
    """
    Processes a blood request and creates an allocation.
    """

    request = Request.objects.get(
         request_ID=request_ID
    )

    if request.status == "Rejected":
         raise ValueError(
              "This request has been rejected."
         )
    
    if request.status == "Fulfilled":
         raise ValueError(
              "This request has already been fulfilled."
         )
    
    inventories = BloodInventory.objects.all()

    for inventory in inventories:
         update_inventory_status(inventory)


    available_blood = BloodInventory.objects.filter(
         blood_group=request.blood_group,
         status__in=["Available", "Near Expiry"]
    ).order_by("collection_date")


    requested_quantity = request.quantity

    available_quantity = available_blood.count()


    if available_quantity == 0:
         raise ValueError(
              "No compatible blood bags available."
          )
    
    allocated_quantity = min(
         requested_quantity,
         available_quantity
    )

    selected_blood = available_blood[:allocated_quantity]

    allocation = Allocation.objects.create(

    allocation_ID=generate_next_ID(
        Allocation,
        "allocation_ID",
        "AL"
    ),

    allocated_quantity=allocated_quantity,

    allocation_date=date.today(),

    allocation_status="Allocated"
)
    
    create_payment(
         allocation,
         selected_blood
    )

    for inventory in selected_blood:
         
         inventory.status = "Allocated"

         inventory.request = request

         inventory.allocation = allocation

         inventory.save(
              update_fields=[
                   "status",
                   "request",
                   "allocation"
                   ]
          )
         
         if allocated_quantity == requested_quantity:
              request.status = "Fulfilled"

         else:
              request.status = "Partial"
              request.save(
                   update_fields=["status"]
                   )