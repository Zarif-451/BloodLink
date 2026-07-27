import 'package:flutter/material.dart';

class BloodGroupChip extends StatelessWidget {
  final String bloodGroup;
  final bool selected;

  const BloodGroupChip({
    super.key,
    required this.bloodGroup,
    this.selected = false,
  });

  static final Map<String, Color> _groupColors = {
    'A+': const Color(0xFFD32F2F),
    'A-': const Color(0xFFE57373),
    'B+': const Color(0xFF1976D2),
    'B-': const Color(0xFF64B5F6),
    'AB+': const Color(0xFF7B1FA2),
    'AB-': const Color(0xFFBA68C8),
    'O+': const Color(0xFFF57C00),
    'O-': const Color(0xFFFFB74D),
  };

  @override
  Widget build(BuildContext context) {
    final color = _groupColors[bloodGroup] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? color : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        bloodGroup,
        style: TextStyle(
          color: selected ? Colors.white : color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}