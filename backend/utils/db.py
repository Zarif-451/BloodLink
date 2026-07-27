from django.db import connection
from django.http import Http404


def fetch_one(sql, params=None):
    with connection.cursor() as cursor:
        cursor.execute(sql, params)
        columns = [col[0] for col in cursor.description]
        row = cursor.fetchone()
        if row is None:
            return None
        return dict(zip(columns, row))


def fetch_all(sql, params=None):
    with connection.cursor() as cursor:
        cursor.execute(sql, params)
        columns = [col[0] for col in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]


def execute(sql, params=None):
    with connection.cursor() as cursor:
        cursor.execute(sql, params)
        return cursor.rowcount


def get_or_404(sql, params, not_found_message=""):
    row = fetch_one(sql, params)
    if row is None:
        if not_found_message:
            raise Http404(not_found_message)
        raise Http404("No %s matches the given query." % sql.split()[1])
    return row


def insert_and_fetch(table, data, model=None):
    if model:
        mapped = {}
        for field_name, value in data.items():
            try:
                db_col = model._meta.get_field(field_name).column
                mapped[db_col] = value
            except Exception:
                mapped[field_name] = value
        data = mapped

    columns = list(data.keys())
    placeholders = ["%s"] * len(columns)
    col_names = ", ".join(columns)
    ph_str = ", ".join(placeholders)
    values = [data[c] for c in columns]

    sql = "INSERT INTO %s (%s) VALUES (%s) RETURNING *" % (table, col_names, ph_str)

    with connection.cursor() as cursor:
        cursor.execute(sql, values)
        columns_out = [col[0] for col in cursor.description]
        row = cursor.fetchone()
        return dict(zip(columns_out, row))


def model_from_row(model, row):
    """Build a model instance from a database row dict, mapping column
    names to model field attnames (e.g. user_ID column -> user_id attr)."""
    col_to_field = {}
    for field in model._meta.get_fields():
        if hasattr(field, "column"):
            col_to_field[field.column] = field

    kwargs = {}
    for col_name, value in row.items():
        field = col_to_field.get(col_name)
        if field:
            kwargs[field.attname] = value
        else:
            kwargs[col_name] = value
    return model(**kwargs)


def dict_diff(original, updated):
    changed = {}
    for key, value in updated.items():
        if key in original and original[key] != value:
            changed[key] = value
    return changed


def update_record(table, set_data, where_cols, where_vals, model=None):
    if model:
        mapped = {}
        for field_name, value in set_data.items():
            try:
                db_col = model._meta.get_field(field_name).column
                mapped[db_col] = value
            except Exception:
                mapped[field_name] = value
        set_data = mapped

    if not set_data:
        return 0

    set_clauses = []
    params = []
    for col, value in set_data.items():
        set_clauses.append("%s = %%s" % col)
        params.append(value)

    for val in where_vals:
        params.append(val)

    where_str = " AND ".join("%s = %%s" % wc for wc in where_cols)
    sql = "UPDATE %s SET %s WHERE %s" % (table, ", ".join(set_clauses), where_str)

    with connection.cursor() as cursor:
        cursor.execute(sql, params)
        return cursor.rowcount