import 'package:flutter/material.dart';

class PhoneNumberFieldList extends StatefulWidget {
  const PhoneNumberFieldList({
    super.key,
    required this.phones,
    required this.onChanged,
  });

  final List<String> phones;
  final ValueChanged<List<String>> onChanged;

  @override
  State<PhoneNumberFieldList> createState() => _PhoneNumberFieldListState();
}

class _PhoneNumberFieldListState extends State<PhoneNumberFieldList> {
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _syncControllers(widget.phones);
  }

  @override
  void didUpdateWidget(covariant PhoneNumberFieldList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phones.length != widget.phones.length) {
      _syncControllers(widget.phones);
    }
  }

  void _syncControllers(List<String> phones) {
    for (final c in _controllers) {
      c.dispose();
    }
    final list = phones.isEmpty ? [''] : phones;
    _controllers = list.map((p) => TextEditingController(text: p)).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _notify() {
    widget.onChanged(_controllers.map((c) => c.text.trim()).toList());
  }

  void _addPhone() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    widget.onChanged([...widget.phones, '']);
  }

  void _removePhone(int index) {
    if (_controllers.length <= 1) return;
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _controllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllers[i],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone ${i + 1}',
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    onChanged: (_) => _notify(),
                  ),
                ),
                if (_controllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _removePhone(i),
                  ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addPhone,
            icon: const Icon(Icons.add),
            label: const Text('Add phone'),
          ),
        ),
      ],
    );
  }
}
