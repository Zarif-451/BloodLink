from datetime import date
from requests.models import Request
from .models import BloodInventory, Allocation
from utils.id_generator import generate_next_ID

def update_inventory_status(inventory):
     """
    Updates the inventory status based on collection_date.

    Rules:
    - Allocated blood remains Allocated.
    - 0-34 days  -> Available
    - 35-41 days -> Near Expiry
    - 42+ days   -> Expired
    """
     
     if inventory_status == "Allocated":
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
         blood_group=Request.blood_group,
         status__in=["Available", "Near Expiry"]
    ).order_by("collection_date")