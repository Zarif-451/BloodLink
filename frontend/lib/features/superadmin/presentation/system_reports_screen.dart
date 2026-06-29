import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/report.dart';
import 'package:frontend/data/repositories/report_repository.dart';

class SystemReportsScreen extends StatefulWidget {
  const SystemReportsScreen({super.key});

  @override
  State<SystemReportsScreen> createState() => _SystemReportsScreenState();
}

class _SystemReportsScreenState extends State<SystemReportsScreen> {
  List<Report> _reports = [];
  bool _loading = true;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<ReportRepository>().getReports();
    if (!mounted) return;
    setState(() {
      _reports = list;
      _loading = false;
    });
  }

  String _userName(int userId) {
    try {
      return MockData.users.firstWhere((u) => u.id == userId).fullName;
    } catch (_) {
      return 'User $userId';
    }
  }

  Future<void> _generate() async {
    final userId = context.read<AuthController>().user?.id;
    if (userId == null) return;

    setState(() => _generating = true);
    try {
      await context.read<ReportRepository>().generateReport(
            userId: userId,
            title: 'System-wide summary',
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report generated')),
      );
      await _load();
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Reports from all branches',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              FilledButton.icon(
                onPressed: _generating ? null : _generate,
                icon: _generating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_chart_outlined, size: 18),
                label: const Text('Generate'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _reports.isEmpty
                  ? const EmptyState(
                      message: 'No reports yet',
                      icon: Icons.assessment_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _reports.length,
                        itemBuilder: (context, index) {
                          final report = _reports[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text(report.title),
                              subtitle: Text(
                                '${_userName(report.generatedByUserId)} · '
                                '${DateFormat.yMMMd().add_jm().format(report.generatedOn)}',
                              ),
                              isThreeLine: true,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(report.title),
                                    content: Text(report.summary),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
