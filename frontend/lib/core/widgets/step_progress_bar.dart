import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.labels,
    required this.currentStep,
  });

  final List<String> labels;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i <= currentStep
                              ? scheme.primary
                              : scheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: i <= currentStep
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: i <= currentStep
                              ? scheme.onPrimary
                              : scheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    if (i < labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < currentStep
                              ? scheme.primary
                              : scheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: i <= currentStep
                            ? scheme.primary
                            : scheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
