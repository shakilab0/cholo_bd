import 'package:flutter/material.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';

class QuickActionsRow extends StatelessWidget {
  final HomePageController controller;
  const QuickActionsRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
          icon: Icons.luggage_rounded,
          label: 'Plan Trip',
          onTap: () => controller.navigateToTripPlanning()),
      _QuickAction(
          icon: Icons.beach_access_rounded,
          label: 'Beaches',
          onTap: () {}),
      _QuickAction(
          icon: Icons.forest_rounded,
          label: 'Nature',
          onTap: () {}),
      _QuickAction(
          icon: Icons.museum_rounded,
          label: 'Heritage',
          onTap: () {}),
      _QuickAction(
          icon: Icons.hiking_rounded,
          label: 'Adventure',
          onTap: () {}),
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _QuickActionChip(action: actions[i]),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});
}

class _QuickActionChip extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionChip({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.bgCard,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(action.icon, color: AppColor.primary, size: 18),
            const SizedBox(width: 6),
            Text(action.label,
                style: AppTextStyle.labelSmall
                    .copyWith(color: AppColor.textPrimary)),
          ],
        ),
      ),
    );
  }
}
