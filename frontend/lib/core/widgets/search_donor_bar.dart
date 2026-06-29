import 'package:flutter/material.dart';

class SearchDonorBar extends StatelessWidget {
  const SearchDonorBar({
    super.key,
    required this.onChanged,
    this.hint = 'Search by national ID, name, or phone',
  });

  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => onChanged(''),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
