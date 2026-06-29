import 'package:flutter/material.dart';

import 'package:frontend/features/staff/inventory/presentation/inventory_list_screen.dart';
import 'package:frontend/features/superadmin/presentation/superadmin_utils.dart';

class BranchInventoryScreen extends StatelessWidget {
  const BranchInventoryScreen({super.key, required this.branchId});

  final int branchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${branchName(branchId)} inventory'),
      ),
      body: InventoryListScreen(branchIdOverride: branchId),
    );
  }
}
