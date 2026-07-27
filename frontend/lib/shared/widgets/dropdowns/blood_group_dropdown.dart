import 'package:flutter/material.dart';

import '../custom_dropdown.dart';
import '../../../config/app_constants.dart';

class BloodGroupDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const BloodGroupDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Blood Group',
      value: value,
      items: AppConstants.bloodGroups
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}