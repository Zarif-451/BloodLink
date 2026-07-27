import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class UserStatusDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;

  const UserStatusDropdown({
    super.key,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Status',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Active', child: Text('Active')),
        DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
        DropdownMenuItem(value: 'Suspended', child: Text('Suspended')),
      ],
      onChanged: onChanged,
    );
  }
}