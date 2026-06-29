import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/data/models/public_request_submission.dart';

class RequestSubmittedScreen extends StatelessWidget {
  const RequestSubmittedScreen({
    super.key,
    required this.requestId,
    required this.bloodGroup,
    required this.quantity,
    required this.urgency,
  });

  final int requestId;
  final String bloodGroup;
  final int quantity;
  final String urgency;

  @override
  Widget build(BuildContext context) {
    final displayId = PublicRequestId.format(requestId);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.check_circle_outline, size: 72, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                'Request submitted',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your request ID',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Text(
                    displayId,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: displayId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request ID copied')),
                  );
                },
                icon: const Icon(Icons.copy_outlined),
                label: const Text('Copy ID'),
              ),
              const SizedBox(height: 16),
              Text(
                'Save this ID and your phone number to track status.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '$bloodGroup · $quantity unit(s) · $urgency · Pending review',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    context.go(AppRoutes.publicTrackById('$requestId')),
                child: const Text('Track this request'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.publicRequest),
                child: const Text('Submit another'),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
