from django.db.models import Max

def generate_next_ID (
        model,
        id_field,
        prefix
):
    result = model.objects.aggregate(
        Max(id_field)
    )

    
    largest_ID = result[
        id_field + "__max"
    ]

    if largest_ID is None:

        return prefix + "0001"
    

    number = largest_ID[len(prefix):]

    number = int(number)

    number = number + 1
    number = f"{number:04d}"

    return prefix + number

