import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class RequesterTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const RequesterTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Requester Type',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Hospital', child: Text('Hospital')),
        DropdownMenuItem(value: 'Individual', child: Text('Individual')),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}