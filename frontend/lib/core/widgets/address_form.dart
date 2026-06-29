import 'package:flutter/material.dart';

class AddressData {
  const AddressData({
    this.street = '',
    this.area = '',
    this.city = '',
    this.postalCode = '',
  });

  final String street;
  final String area;
  final String city;
  final String postalCode;

  AddressData copyWith({
    String? street,
    String? area,
    String? city,
    String? postalCode,
  }) {
    return AddressData(
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}

class AddressForm extends StatelessWidget {
  const AddressForm({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final AddressData value;
  final ValueChanged<AddressData> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Street',
            prefixIcon: Icon(Icons.home_outlined),
          ),
          controller: TextEditingController(text: value.street),
          onChanged: (v) => onChanged(value.copyWith(street: v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Area'),
          controller: TextEditingController(text: value.area),
          onChanged: (v) => onChanged(value.copyWith(area: v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'City'),
          controller: TextEditingController(text: value.city),
          onChanged: (v) => onChanged(value.copyWith(city: v)),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Postal code'),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: value.postalCode),
          onChanged: (v) => onChanged(value.copyWith(postalCode: v)),
        ),
      ],
    );
  }
}
