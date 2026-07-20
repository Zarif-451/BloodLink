from inventory.models import Allocation


def assign_transport_to_allocations(
    transport,
    allocation_IDs
):

    for allocation_ID in allocation_IDs:

        allocation = Allocation.objects.get(
            allocation_ID=allocation_ID
        )

        if allocation.transport is not None:

            raise ValueError(
                f"{allocation_ID} is already assigned to another transport."
            )

        allocation.transport = transport

        allocation.save(
            update_fields=[
                "transport"
            ]
        )