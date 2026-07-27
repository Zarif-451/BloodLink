from utils.db import fetch_one, update_record
from inventory.models import Allocation


def assign_transport_to_allocations(transport_row, allocation_IDs):
    for allocation_ID in allocation_IDs:
        row = fetch_one(
            "SELECT transport_ID FROM Allocations WHERE allocation_ID = %s",
            [allocation_ID]
        )

        if row is None:
            raise ValueError(f"Allocation {allocation_ID} not found.")

        if row["transport_ID"] is not None:
            raise ValueError(
                f"{allocation_ID} is already assigned to another transport."
            )

        update_record(
            "Allocations",
            {"transport_ID": transport_row["transport_ID"]},
            ["allocation_ID"],
            [allocation_ID],
            model=Allocation
        )