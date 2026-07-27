import json
from datetime import date

from .models import Report

from utils.id_generator import generate_next_ID
from utils.db import fetch_one, insert_and_fetch, model_from_row


def generate_report(user):
    try:

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Donations")
        total_donations = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Blood_Inventory WHERE status = %s", ["Available"])
        available_blood = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Blood_Inventory WHERE status = %s", ["Near Expiry"])
        near_expiry_blood = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Blood_Inventory WHERE status = %s", ["Expired"])
        expired_blood = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Requests WHERE status = %s", ["Pending"])
        pending_requests = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Requests WHERE status = %s", ["Fulfilled"])
        fulfilled_requests = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Requests WHERE status = %s", ["Partial"])
        partial_requests = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Requests WHERE status = %s", ["Rejected"])
        rejected_requests = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Payments WHERE payment_status = %s", ["Completed"])
        completed_payments = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Payments WHERE payment_status = %s", ["Pending"])
        pending_payments = row["cnt"]

        row = fetch_one("SELECT COUNT(*) AS cnt FROM Payments WHERE payment_status = %s", ["Failed"])
        failed_payments = row["cnt"]

        row = fetch_one(
            "SELECT COALESCE(SUM(payment_amount), 0) AS total FROM Payments WHERE payment_status = %s",
            ["Completed"]
        )
        total_revenue = row["total"]

    except Exception:
        raise ValueError(
            "Failed to collect report statistics."
        )

    report_data = {
        "total_donations": total_donations,
        "available_blood": available_blood,
        "near_expiry_blood": near_expiry_blood,
        "expired_blood": expired_blood,
        "pending_requests": pending_requests,
        "fulfilled_requests": fulfilled_requests,
        "partial_requests": partial_requests,
        "rejected_requests": rejected_requests,
        "completed_payments": completed_payments,
        "pending_payments": pending_payments,
        "failed_payments": failed_payments,
        "total_revenue": float(total_revenue)
    }

    try:
        report_data_for_db = {
            "report_ID": generate_next_ID("Reports", "report_ID", "RPT"),
            "generated_on": date.today(),
            "report_data": json.dumps(report_data, indent=4),
            "user": user.user_ID,
        }

        row = insert_and_fetch("Reports", report_data_for_db, model=Report)

    except Exception:
        raise ValueError(
            "Failed to generate report."
        )

    return model_from_row(Report, row)