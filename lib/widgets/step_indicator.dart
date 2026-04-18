import 'package:flutter/material.dart';

/// Shows which step the user is on (dots + label)
/// currentStep: 0-based index of the active step
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String label;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // Dots
        ...List.generate(totalSteps, (i) {
          final isActive = i == currentStep;
          final isDone = i < currentStep;
          return Container(
            margin: const EdgeInsets.only(right: 6),
            width: isActive ? 10 : 8,
            height: isActive ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? color
                  : isDone
                      ? color.withOpacity(0.4)
                      : Colors.grey.shade300,
            ),
          );
        }),
        const SizedBox(width: 8),
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
