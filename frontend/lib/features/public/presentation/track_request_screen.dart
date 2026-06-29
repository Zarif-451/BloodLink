import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/data/repositories/request_repository.dart';

class TrackRequestScreen extends StatefulWidget {
  const TrackRequestScreen({super.key});

  @override
  State<TrackRequestScreen> createState() => _TrackRequestScreenState();
}

class _TrackRequestScreenState extends State<TrackRequestScreen> {
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _callBranch() async {
    final uri = Uri.parse('tel:${AppRoutes.staffBranchHotline}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _track() async {
    if (_idController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      setState(() => _error = 'Enter request ID and phone number');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final request = await context.read<RequestRepository>().trackRequest(
          requestIdInput: _idController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _loading = false);

    if (request == null) {
      setState(
        () => _error = 'No request found — check ID and phone number',
      );
      return;
    }

    context.go(AppRoutes.publicTrackById('${request.id}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track your request')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Request ID *',
              hintText: 'BL-1042 or 1042',
              prefixIcon: Icon(Icons.tag),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone number *',
              hintText: 'Number used when submitting',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _track,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Track request'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go(AppRoutes.publicRequest),
            child: const Text("Don't have an ID? Submit a new request"),
          ),
          const Divider(height: 32),
          Text(
            'Contact blood bank',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _callBranch,
            icon: const Icon(Icons.phone_outlined),
            label: Text('Call ${AppRoutes.staffBranchHotline}'),
          ),
        ],
      ),
    );
  }
}
