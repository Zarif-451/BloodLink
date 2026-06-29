import 'package:flutter/material.dart';

/// Placeholder screen until Phase 1+ implements the real UI.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.construction_outlined,
    this.wrapScaffold = true,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool wrapScaffold;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
          ],
        ),
      ),
    );

    if (!wrapScaffold) return content;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    );
  }
}
