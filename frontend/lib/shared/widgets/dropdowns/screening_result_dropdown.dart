import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class ScreeningResultDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const ScreeningResultDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Result',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Eligible', child: Text('Eligible')),
        DropdownMenuItem(value: 'Ineligible', child: Text('Ineligible')),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}