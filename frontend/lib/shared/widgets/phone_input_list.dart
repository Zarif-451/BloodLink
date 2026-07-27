import 'package:flutter/material.dart';

class PhoneInputList extends StatelessWidget {
  final List<String> phoneNumbers;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onDelete;

  const PhoneInputList({
    super.key,
    required this.phoneNumbers,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...phoneNumbers.map(
          (phone) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.phone),
            title: Text(phone),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onDelete(phone),
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.add),
          title: const Text('Add Phone'),
          onTap: () => _showAddDialog(context),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Phone'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '01XXXXXXXXX',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final phone = controller.text.trim();
              if (phone.isNotEmpty) {
                onAdd(phone);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}