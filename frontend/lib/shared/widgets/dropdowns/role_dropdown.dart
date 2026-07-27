import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class RoleDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const RoleDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Role',
      value: value,
      items: const [
        DropdownMenuItem(value: 'SuperAdmin', child: Text('SuperAdmin')),
        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
        DropdownMenuItem(value: 'Staff', child: Text('Staff')),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}