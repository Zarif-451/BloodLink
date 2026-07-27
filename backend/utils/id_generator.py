from utils.db import fetch_one


def generate_next_ID(table_name, id_column, prefix):
    row = fetch_one(
        "SELECT MAX(%s) AS max_id FROM %s" % (id_column, table_name)
    )
    largest_ID = row["max_id"]

    if largest_ID is None:
        return prefix + "0001"

    number = int(largest_ID[len(prefix):])
    number += 1
    return prefix + "%04d" % number