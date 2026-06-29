import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/models/branch.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/models/payment.dart';
import 'package:frontend/data/models/screening.dart';
import 'package:frontend/data/models/report.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/models/user.dart';

/// Central mock seed data for Phase 0–1 development.
abstract final class MockData {
  static const dhakaBranchId = 1;
  static const chittagongBranchId = 2;

  static final branches = [
    const Branch(
      id: dhakaBranchId,
      name: 'CUET Blood Bank · Dhaka',
      district: 'Dhaka',
      city: 'Dhaka',
      phones: ['01700000001'],
    ),
    const Branch(
      id: chittagongBranchId,
      name: 'CUET Blood Bank · Chattogram',
      district: 'Chattogram',
      city: 'Chattogram',
      phones: ['01800000001'],
    ),
  ];

  static final users = [
    const AppUser(
      id: 1,
      fullName: 'Fatima Rahman',
      email: 'staff@cuet.edu.bd',
      role: UserRole.staff,
      branchId: dhakaBranchId,
      phones: ['01711111111'],
    ),
    const AppUser(
      id: 2,
      fullName: 'Karim Ahmed',
      email: 'admin@cuet.edu.bd',
      role: UserRole.admin,
      branchId: dhakaBranchId,
      phones: ['01722222222'],
    ),
    const AppUser(
      id: 3,
      fullName: 'System Admin',
      email: 'super@cuet.edu.bd',
      role: UserRole.superadmin,
      branchId: dhakaBranchId,
      phones: ['01733333333'],
    ),
  ];

  static final donors = [
    Donor(
      nationalId: '1998123456789',
      fullName: 'Rahim Uddin',
      bloodGroup: BloodGroup.oPositive,
      dateOfBirth: DateTime(1998, 3, 15),
      gender: Gender.male,
      city: 'Dhaka',
      phones: ['01912345678'],
      lastDonationDate: DateTime.now().subtract(const Duration(days: 70)),
      eligibleNextDate: DateTime.now().subtract(const Duration(days: 14)),
    ),
    Donor(
      nationalId: '1995123456780',
      fullName: 'Sadia Akter',
      bloodGroup: BloodGroup.aNegative,
      dateOfBirth: DateTime(1995, 8, 22),
      gender: Gender.female,
      city: 'Dhaka',
      phones: ['01812345678'],
      eligibleNextDate: DateTime.now().add(const Duration(days: 20)),
    ),
    Donor(
      nationalId: '2000123456781',
      fullName: 'Tanvir Hasan',
      bloodGroup: BloodGroup.bPositive,
      dateOfBirth: DateTime(2000, 1, 10),
      gender: Gender.male,
      city: 'Narayanganj',
      phones: ['01612345678'],
    ),
    Donor(
      nationalId: '1992123456782',
      fullName: 'Nusrat Jahan',
      bloodGroup: BloodGroup.abPositive,
      dateOfBirth: DateTime(1992, 11, 5),
      gender: Gender.female,
      city: 'Dhaka',
      phones: ['01512345678'],
      lastDonationDate: DateTime.now().subtract(const Duration(days: 30)),
      eligibleNextDate: DateTime.now().add(const Duration(days: 26)),
    ),
    Donor(
      nationalId: '1997123456783',
      fullName: 'Imran Hossain',
      bloodGroup: BloodGroup.oNegative,
      dateOfBirth: DateTime(1997, 6, 18),
      gender: Gender.male,
      city: 'Gazipur',
      phones: ['01312345678'],
    ),
  ];

  static final donations = [
    Donation(
      id: 1,
      nationalId: '1998123456789',
      unitsDonated: 1,
      donationDate: DateTime.now().subtract(const Duration(days: 70)),
      eligibleNextDate: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  static List<Screening> screenings = [];

  static List<InventoryUnit> inventory = [
    InventoryUnit(
      id: 1,
      branchId: dhakaBranchId,
      bloodGroup: BloodGroup.oPositive,
      unitNumber: 'DH-O+-001',
      collectionDate: DateTime.now().subtract(const Duration(days: 5)),
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 2,
      branchId: dhakaBranchId,
      bloodGroup: BloodGroup.aNegative,
      unitNumber: 'DH-A--002',
      collectionDate: DateTime.now().subtract(const Duration(days: 28)),
      expiryDate: DateTime.now().add(const Duration(days: 5)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 3,
      branchId: dhakaBranchId,
      bloodGroup: BloodGroup.oNegative,
      unitNumber: 'DH-O--003',
      collectionDate: DateTime.now().subtract(const Duration(days: 10)),
      expiryDate: DateTime.now().add(const Duration(days: 25)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 4,
      branchId: dhakaBranchId,
      bloodGroup: BloodGroup.aPositive,
      unitNumber: 'DH-A+-004',
      collectionDate: DateTime.now().subtract(const Duration(days: 3)),
      expiryDate: DateTime.now().add(const Duration(days: 32)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 5,
      branchId: chittagongBranchId,
      bloodGroup: BloodGroup.aPositive,
      unitNumber: 'CT-A+-001',
      collectionDate: DateTime.now().subtract(const Duration(days: 4)),
      expiryDate: DateTime.now().add(const Duration(days: 31)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 6,
      branchId: chittagongBranchId,
      bloodGroup: BloodGroup.oNegative,
      unitNumber: 'CT-O--001',
      collectionDate: DateTime.now().subtract(const Duration(days: 6)),
      expiryDate: DateTime.now().add(const Duration(days: 29)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 7,
      branchId: chittagongBranchId,
      bloodGroup: BloodGroup.oNegative,
      unitNumber: 'CT-O--002',
      collectionDate: DateTime.now().subtract(const Duration(days: 8)),
      expiryDate: DateTime.now().add(const Duration(days: 27)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 8,
      branchId: chittagongBranchId,
      bloodGroup: BloodGroup.oNegative,
      unitNumber: 'CT-O--003',
      collectionDate: DateTime.now().subtract(const Duration(days: 2)),
      expiryDate: DateTime.now().add(const Duration(days: 33)),
      quantity: 1,
      status: InventoryStatus.available,
    ),
    InventoryUnit(
      id: 9,
      branchId: dhakaBranchId,
      bloodGroup: BloodGroup.bPositive,
      unitNumber: 'DH-B+-001',
      collectionDate: DateTime.now().subtract(const Duration(days: 7)),
      expiryDate: DateTime.now().add(const Duration(days: 28)),
      quantity: 1,
      status: InventoryStatus.reserved,
    ),
  ];

  static List<Requester> requesters = [
    const Requester(
      id: 1,
      type: RequesterType.hospital,
      name: 'Square Hospital',
      city: 'Dhaka',
      phones: ['01710000001'],
    ),
    const Requester(
      id: 2,
      type: RequesterType.hospital,
      name: 'DMCH Emergency',
      city: 'Dhaka',
      phones: ['01710000002'],
    ),
    const Requester(
      id: 3,
      type: RequesterType.hospital,
      name: 'United Hospital',
      city: 'Dhaka',
      phones: ['01710000003'],
    ),
  ];

  static List<BloodRequest> requests = [
    BloodRequest(
      id: 1042,
      requesterId: 1,
      bloodGroup: BloodGroup.aPositive,
      quantity: 2,
      urgency: Urgency.critical,
      requestDate: DateTime.now().subtract(const Duration(hours: 2)),
      status: RequestStatus.pending,
      requesterName: 'Square Hospital',
    ),
    BloodRequest(
      id: 1041,
      requesterId: 2,
      bloodGroup: BloodGroup.oNegative,
      quantity: 4,
      urgency: Urgency.urgent,
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      status: RequestStatus.approved,
      requesterName: 'DMCH Emergency',
    ),
    BloodRequest(
      id: 1038,
      requesterId: 3,
      bloodGroup: BloodGroup.bPositive,
      quantity: 1,
      urgency: Urgency.normal,
      requestDate: DateTime.now().subtract(const Duration(days: 3)),
      status: RequestStatus.allocated,
      requesterName: 'United Hospital',
    ),
  ];

  static List<Allocation> allocations = [
    Allocation(
      id: 1,
      requestId: 1038,
      transportId: 1,
      allocatedQuantity: 1,
      allocationDate: DateTime.now().subtract(const Duration(days: 2)),
      status: AllocationStatus.confirmed,
      inventoryIds: const [9],
    ),
  ];

  static List<Transport> transports = [
    Transport(
      id: 1,
      sourceBranchId: chittagongBranchId,
      destinationType: DestinationType.branch,
      destinationName: 'CUET Blood Bank · Dhaka',
      status: TransportStatus.inTransit,
      dispatchedTime: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  static List<Payment> payments = [
    Payment(
      id: 1,
      allocationId: 1,
      requestId: 1041,
      amount: 2500,
      paymentDate: DateTime.now().subtract(const Duration(days: 1)),
      status: PaymentStatus.pending,
      reason: 'Unit distribution fee',
    ),
  ];

  static final reports = [
    Report(
      id: 1,
      generatedByUserId: 2,
      generatedOn: DateTime.now().subtract(const Duration(days: 7)),
      title: 'Monthly inventory summary',
      summary: '128 units across all groups',
    ),
  ];

  static AppUser? loggedInUser;
}
