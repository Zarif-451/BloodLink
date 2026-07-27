import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  static const List<String> urgencyLevels = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  static const List<String> inventoryStatuses = [
    'Available',
    'Near Expiry',
    'Expired',
    'Allocated',
  ];

  static const List<String> requestStatuses = [
    'Pending',
    'Partial',
    'Fulfilled',
    'Rejected',
  ];

  static const List<String> transportStatuses = [
    'Pending',
    'In Transit',
    'Delivered',
    'Cancelled',
  ];

  static const List<String> paymentStatuses = [
    'Pending',
    'Completed',
    'Failed',
  ];

  static const Map<String, Color> statusColors = {
    'Available': Color(0xFF2E7D32),
    'Near Expiry': Color(0xFFEF6C00),
    'Expired': Color(0xFFC62828),
    'Allocated': Color(0xFF1565C0),
    'Pending': Color(0xFFF57F17),
    'Partial': Color(0xFF1565C0),
    'Fulfilled': Color(0xFF2E7D32),
    'Rejected': Color(0xFFC62828),
    'In Transit': Color(0xFF1565C0),
    'Delivered': Color(0xFF2E7D32),
    'Cancelled': Color(0xFFC62828),
    'Completed': Color(0xFF2E7D32),
    'Failed': Color(0xFFC62828),
  };
}