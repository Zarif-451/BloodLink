import 'package:flutter/material.dart';

import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/branch.dart';

/// Pick a branch to fulfill a request as superadmin.
Future<int?> showFulfillingBranchPicker(BuildContext context) {
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Fulfilling branch'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text('Select which branch will fulfill this request.'),
            const SizedBox(height: 12),
            for (final branch in MockData.branches)
              ListTile(
                title: Text(branch.name),
                subtitle: Text(branch.city.isNotEmpty ? branch.city : branch.district),
                onTap: () => Navigator.pop(context, branch.id),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

String branchName(int id) =>
    MockData.branches.firstWhere((b) => b.id == id, orElse: () => const Branch(
          id: 0,
          name: 'Unknown',
          district: '',
        )).name;
