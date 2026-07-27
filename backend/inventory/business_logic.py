from datetime import date
from utils.id_generator import generate_next_ID
from utils.db import fetch_one, fetch_all, insert_and_fetch, update_record, execute
from .models import BloodInventory, Allocation


def update_inventory_status(inventory):
    """
    Updates the inventory status based on collection_date.
    Rules:
    - Allocated blood remains Allocated.
    - 0-34 days  -> Available
    - 35-41 days -> Near Expiry
    - 42+ days   -> Expired
    """
    status = inventory["status"]
    if status == "Allocated":
        return

    days_stored = (date.today() - inventory["collection_date"]).days

    if days_stored >= 42:
        new_status = "Expired"
    elif days_stored >= 35:
        new_status = "Near Expiry"
    else:
        new_status = "Available"

    if status != new_status:
        try:
            update_record(
                "Blood_Inventory",
                {"status": new_status},
                ["inventory_ID"],
                [inventory["inventory_ID"]],
                model=BloodInventory
            )
            inventory["status"] = new_status
        except Exception:
            raise ValueError(
                f"Failed to update inventory status for {inventory['inventory_ID']}."
            )


def create_allocation(request_ID):
    request_row = fetch_one(
        "SELECT * FROM Requests WHERE request_ID = %s",
        [request_ID]
    )

    if request_row is None:
        raise ValueError("Request not found.")

    if request_row["status"] == "Rejected":
        raise ValueError("This request has been rejected.")

    if request_row["status"] == "Fulfilled":
        raise ValueError("This request has already been fulfilled.")

    inventories = fetch_all("SELECT * FROM Blood_Inventory")

    for inv in inventories:
        update_inventory_status(inv)

    available_blood = fetch_all(
        "SELECT * FROM Blood_Inventory WHERE blood_group = %s AND status IN (%s, %s) ORDER BY collection_date",
        [request_row["blood_group"], "Available", "Near Expiry"]
    )

    requested_quantity = request_row["quantity"]
    available_quantity = len(available_blood)

    if available_quantity == 0:
        raise ValueError("No compatible blood bags available.")

    allocated_quantity = min(requested_quantity, available_quantity)
    selected_blood = available_blood[:allocated_quantity]

    try:
        allocation_row = insert_and_fetch(
            "Allocations",
            {
                "allocation_ID": generate_next_ID("Allocations", "allocation_ID", "AL"),
                "allocated_quantity": allocated_quantity,
                "allocation_date": date.today(),
                "allocation_status": "Allocated",
            },
            model=Allocation
        )
    except Exception:
        raise ValueError("Failed to create allocation.")

    from payment.business_logic import create_payment
    create_payment(allocation_row, selected_blood)

    for inv in selected_blood:
        try:
            update_record(
                "Blood_Inventory",
                {
                    "status": "Allocated",
                    "request_ID": request_row["request_ID"],
                    "allocation_ID": allocation_row["allocation_ID"],
                },
                ["inventory_ID"],
                [inv["inventory_ID"]],
                model=BloodInventory
            )
        except Exception:
            raise ValueError(
                f"Failed to update inventory {inv['inventory_ID']}."
            )

    if allocated_quantity == requested_quantity:
        new_request_status = "Fulfilled"
    else:
        new_request_status = "Partial"

    try:
        update_record(
            "Requests",
            {"status": new_request_status},
            ["request_ID"],
            [request_ID],
        )
    except Exception:
        raise ValueError("Failed to update request.")

    return allocation_row