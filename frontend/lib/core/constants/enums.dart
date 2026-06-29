import 'status_tone.dart';

enum UserRole { superadmin, admin, staff }

enum UserStatus { active, inactive, suspended }

enum BloodGroup { aPositive, aNegative, bPositive, bNegative, abPositive, abNegative, oPositive, oNegative }

enum Gender { male, female }

enum RequesterType { hospital, individual, bloodBank }

extension RequesterTypeX on RequesterType {
  String get label => switch (this) {
        RequesterType.hospital => 'Hospital',
        RequesterType.individual => 'Individual',
        RequesterType.bloodBank => 'Blood bank',
      };
}

enum Urgency { normal, urgent, critical }

enum DestinationType { hospital, branch }

enum BranchStatus { active, inactive, maintenance }

enum InventoryStatus { available, reserved, expired, discarded, inTransit }

enum RequestStatus { pending, approved, rejected, allocated, inTransit, fulfilled, cancelled }

enum TransportStatus { pending, dispatched, inTransit, delivered, cancelled }

enum AllocationStatus { pending, confirmed, delivered, cancelled }

enum PaymentStatus { pending, paid, waived, failed }

enum ScreeningResult { pass, fail }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.superadmin => 'Superadmin',
        UserRole.admin => 'Admin',
        UserRole.staff => 'Staff',
      };

  static UserRole fromDb(String value) => switch (value.toLowerCase()) {
        'superadmin' => UserRole.superadmin,
        'admin' => UserRole.admin,
        _ => UserRole.staff,
      };
}

extension BloodGroupX on BloodGroup {
  String get label => switch (this) {
        BloodGroup.aPositive => 'A+',
        BloodGroup.aNegative => 'A−',
        BloodGroup.bPositive => 'B+',
        BloodGroup.bNegative => 'B−',
        BloodGroup.abPositive => 'AB+',
        BloodGroup.abNegative => 'AB−',
        BloodGroup.oPositive => 'O+',
        BloodGroup.oNegative => 'O−',
      };

  static BloodGroup fromLabel(String value) {
    for (final g in BloodGroup.values) {
      if (g.label == value) return g;
    }
    return BloodGroup.oPositive;
  }
}

extension UrgencyX on Urgency {
  String get label => switch (this) {
        Urgency.normal => 'Normal',
        Urgency.urgent => 'Urgent',
        Urgency.critical => 'Critical',
      };

  static Urgency fromLabel(String value) => switch (value.toLowerCase()) {
        'urgent' => Urgency.urgent,
        'critical' => Urgency.critical,
        _ => Urgency.normal,
      };
}

extension RequestStatusX on RequestStatus {
  String get label => switch (this) {
        RequestStatus.pending => 'Pending',
        RequestStatus.approved => 'Approved',
        RequestStatus.rejected => 'Rejected',
        RequestStatus.allocated => 'Allocated',
        RequestStatus.inTransit => 'In Transit',
        RequestStatus.fulfilled => 'Fulfilled',
        RequestStatus.cancelled => 'Cancelled',
      };

  StatusTone get tone => switch (this) {
        RequestStatus.pending => StatusTone.warning,
        RequestStatus.approved => StatusTone.success,
        RequestStatus.rejected => StatusTone.critical,
        RequestStatus.allocated => StatusTone.info,
        RequestStatus.inTransit => StatusTone.info,
        RequestStatus.fulfilled => StatusTone.success,
        RequestStatus.cancelled => StatusTone.neutral,
      };

  static RequestStatus fromLabel(String value) => switch (value.toLowerCase().replaceAll(' ', '')) {
        'approved' => RequestStatus.approved,
        'rejected' => RequestStatus.rejected,
        'allocated' => RequestStatus.allocated,
        'intransit' => RequestStatus.inTransit,
        'fulfilled' => RequestStatus.fulfilled,
        'cancelled' => RequestStatus.cancelled,
        _ => RequestStatus.pending,
      };
}

extension InventoryStatusX on InventoryStatus {
  String get label => switch (this) {
        InventoryStatus.available => 'Available',
        InventoryStatus.reserved => 'Reserved',
        InventoryStatus.expired => 'Expired',
        InventoryStatus.discarded => 'Discarded',
        InventoryStatus.inTransit => 'In Transit',
      };

  StatusTone get tone => switch (this) {
        InventoryStatus.available => StatusTone.success,
        InventoryStatus.reserved => StatusTone.warning,
        InventoryStatus.expired => StatusTone.critical,
        InventoryStatus.discarded => StatusTone.neutral,
        InventoryStatus.inTransit => StatusTone.info,
      };
}

extension TransportStatusX on TransportStatus {
  String get label => switch (this) {
        TransportStatus.pending => 'Pending',
        TransportStatus.dispatched => 'Dispatched',
        TransportStatus.inTransit => 'In Transit',
        TransportStatus.delivered => 'Delivered',
        TransportStatus.cancelled => 'Cancelled',
      };

  StatusTone get tone => switch (this) {
        TransportStatus.pending => StatusTone.warning,
        TransportStatus.dispatched => StatusTone.info,
        TransportStatus.inTransit => StatusTone.info,
        TransportStatus.delivered => StatusTone.success,
        TransportStatus.cancelled => StatusTone.neutral,
      };
}

extension PaymentStatusX on PaymentStatus {
  String get label => switch (this) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.waived => 'Waived',
        PaymentStatus.failed => 'Failed',
      };
}

extension ScreeningResultX on ScreeningResult {
  String get label => switch (this) {
        ScreeningResult.pass => 'Pass',
        ScreeningResult.fail => 'Fail',
      };
}

extension BranchStatusX on BranchStatus {
  String get label => switch (this) {
        BranchStatus.active => 'Active',
        BranchStatus.inactive => 'Inactive',
        BranchStatus.maintenance => 'Maintenance',
      };
}

extension UserStatusX on UserStatus {
  String get label => switch (this) {
        UserStatus.active => 'Active',
        UserStatus.inactive => 'Inactive',
        UserStatus.suspended => 'Suspended',
      };
}
