import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class BranchStatusDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;

  const BranchStatusDropdown({
    super.key,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Branch Status',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Active', child: Text('Active')),
        DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
      ],
      onChanged: onChanged,
    );
  }
}