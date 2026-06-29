import 'package:flutter/material.dart';

class TimelineStep {
  const TimelineStep({
    required this.title,
    this.subtitle,
    this.isComplete = false,
    this.isActive = false,
  });

  final String title;
  final String? subtitle;
  final bool isComplete;
  final bool isActive;
}

class TimelineStepper extends StatelessWidget {
  const TimelineStepper({super.key, required this.steps});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _TimelineRow(
            step: steps[i],
            isLast: i == steps.length - 1,
            scheme: scheme,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.step,
    required this.isLast,
    required this.scheme,
  });

  final TimelineStep step;
  final bool isLast;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final dotColor = step.isComplete
        ? scheme.primary
        : step.isActive
            ? scheme.secondary
            : scheme.outline;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isComplete || step.isActive
                        ? dotColor
                        : Colors.transparent,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: step.isComplete
                          ? scheme.primary
                          : scheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight:
                              step.isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                  if (step.subtitle != null)
                    Text(
                      step.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
