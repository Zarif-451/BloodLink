import 'package:flutter/material.dart';

import 'samples/sample_dashboard.dart';
import 'samples/sample_login.dart';
import 'samples/sample_requests.dart';

/// UI preview for Crimson Clinical — toggle light/dark from the app bar.
class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  int _pageIndex = 0;
  late final PageController _pageController;

  static const _pages = [
    ('Login', SampleLoginPage()),
    ('Dashboard', SampleDashboardPage()),
    ('Requests', SampleRequestsPage()),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isDark => widget.themeMode == ThemeMode.dark;

  void _toggleTheme() {
    widget.onThemeModeChanged(_isDark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BloodLink'),
            Text(
              'Crimson Clinical · ${_isDark ? 'Dark' : 'Light'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: _toggleTheme,
            icon: Icon(_isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Classic blood-bank red with clean surfaces — tap the moon/sun icon to preview dark mode.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
            ),
          ),
          _PageTabs(
            labels: _pages.map((p) => p.$1).toList(),
            selectedIndex: _pageIndex,
            onSelected: (i) {
              setState(() => _pageIndex = i);
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            },
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              children: _pages.map((p) => p.$2).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageTabs extends StatelessWidget {
  const _PageTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SegmentedButton<int>(
        segments: [
          for (var i = 0; i < labels.length; i++)
            ButtonSegment(value: i, label: Text(labels[i])),
        ],
        selected: {selectedIndex},
        onSelectionChanged: (s) => onSelected(s.first),
      ),
    );
  }
}
