import 'package:flutter/material.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';

class PlanningProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const PlanningProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  static const _labels = [
    'District',
    'Places',
    'Date',
    'Transport',
    'Confirm',
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style:
                    AppTextStyle.labelSmall.copyWith(color: AppColor.primary),
              ),
              Text(
                _labels[currentStep.clamp(0, _labels.length - 1)],
                style: AppTextStyle.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColor.border,
              color: AppColor.primary,
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }
}
