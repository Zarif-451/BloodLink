import json
from datetime import date

from django.db.models import Sum

from .models import Report

from donations.models import Donation
from inventory.models import BloodInventory
from requests.models import Request
from payment.models import Payment

from utils.id_generator import generate_next_ID


def generate_report(user):
    """
    Generates a nationwide system report.
    """

    try:

        total_donations = Donation.objects.count()

        available_blood = BloodInventory.objects.filter(
            status="Available"
        ).count()

        near_expiry_blood = BloodInventory.objects.filter(
            status="Near Expiry"
        ).count()

        expired_blood = BloodInventory.objects.filter(
            status="Expired"
        ).count()

        pending_requests = Request.objects.filter(
            status="Pending"
        ).count()

        fulfilled_requests = Request.objects.filter(
            status="Fulfilled"
        ).count()

        partial_requests = Request.objects.filter(
            status="Partial"
        ).count()

        rejected_requests = Request.objects.filter(
            status="Rejected"
        ).count()

        completed_payments = Payment.objects.filter(
            payment_status="Completed"
        ).count()

        pending_payments = Payment.objects.filter(
            payment_status="Pending"
        ).count()

        failed_payments = Payment.objects.filter(
            payment_status="Failed"
        ).count()

        total_revenue = Payment.objects.filter(
            payment_status="Completed"
        ).aggregate(
            total=Sum("payment_amount")
        )["total"] or 0

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

        report = Report.objects.create(

            report_ID=generate_next_ID(
                Report,
                "report_ID",
                "RPT"
            ),

            generated_on=date.today(),

            report_data=json.dumps(
                report_data,
                indent=4
            ),

            user=user
        )

    except Exception:

        raise ValueError(
            "Failed to generate report."
        )

    return report