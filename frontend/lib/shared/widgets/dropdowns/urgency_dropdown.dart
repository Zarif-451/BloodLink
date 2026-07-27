import 'package:flutter/material.dart';

import '../custom_dropdown.dart';
import '../../../config/app_constants.dart';

class UrgencyDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const UrgencyDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Urgency',
      value: value,
      items: AppConstants.urgencyLevels
          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}