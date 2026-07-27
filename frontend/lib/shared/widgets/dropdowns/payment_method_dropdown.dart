import 'package:flutter/material.dart';
import '../custom_dropdown.dart';

class PaymentMethodDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;

  const PaymentMethodDropdown({
    super.key,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      label: 'Payment Method',
      value: value,
      items: const [
        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
        DropdownMenuItem(value: 'Card', child: Text('Card')),
        DropdownMenuItem(value: 'Mobile Banking', child: Text('Mobile Banking')),
        DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
      ],
      onChanged: onChanged,
    );
  }
}