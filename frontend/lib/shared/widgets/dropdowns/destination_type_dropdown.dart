import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class DestinationTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const DestinationTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Destination Type',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Hospital', child: Text('Hospital')),
        DropdownMenuItem(value: 'Branch', child: Text('Branch')),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}