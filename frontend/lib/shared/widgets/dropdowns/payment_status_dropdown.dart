import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class PaymentStatusDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;

  const PaymentStatusDropdown({
    super.key,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Payment Status',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
        DropdownMenuItem(value: 'Completed', child: Text('Completed')),
        DropdownMenuItem(value: 'Failed', child: Text('Failed')),
      ],
      onChanged: onChanged,
    );
  }
}