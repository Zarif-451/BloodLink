import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class TransportStatusDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;

  const TransportStatusDropdown({
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
        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
        DropdownMenuItem(value: 'In Transit', child: Text('In Transit')),
        DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
        DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
      ],
      onChanged: onChanged,
    );
  }
}