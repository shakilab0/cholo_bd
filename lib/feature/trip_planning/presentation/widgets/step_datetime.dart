import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepDatetime extends StatelessWidget {
  final TripPlanningController controller;
  const StepDatetime({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('When are you going?', style: AppTextStyle.heading3),
          const SizedBox(height: 20),
          Text('Quick pick', style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary)),
          const SizedBox(height: 10),
          Obx(() {
            final selected = controller.selectedDate.value;
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = today.add(const Duration(days: 1));

            String? quickLabel;
            if (selected == today) {
              quickLabel = 'today';
            } else if (selected == tomorrow) {
              quickLabel = 'tomorrow';
            } else {
              final daysUntilSat = (6 - now.weekday) % 7;
              final offset = daysUntilSat == 0 ? 7 : daysUntilSat;
              final weekend = DateTime(now.year, now.month, now.day + offset);
              if (selected == weekend) quickLabel = 'weekend';
            }

            return Wrap(
              spacing: 10,
              children: [
                _QuickChip(
                  label: 'Today',
                  selected: quickLabel == 'today',
                  onTap: () => controller.selectDateQuick(0),
                ),
                _QuickChip(
                  label: 'Tomorrow',
                  selected: quickLabel == 'tomorrow',
                  onTap: () => controller.selectDateQuick(1),
                ),
                _QuickChip(
                  label: 'This Weekend',
                  selected: quickLabel == 'weekend',
                  onTap: controller.selectThisWeekend,
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          Text('Pick a date', style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary)),
          const SizedBox(height: 10),
          Obx(() {
            final selected = controller.selectedDate.value;
            return CalendarDatePicker(
              initialDate: selected,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: controller.selectDate,
            );
          }),
          const SizedBox(height: 20),
          Obx(() {
            final selected = controller.selectedDate.value;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_rounded, color: AppColor.primary, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected date', style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary)),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(selected),
                        style: AppTextStyle.sectionTitle,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColor.primary : AppColor.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColor.primary : AppColor.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.labelSmall.copyWith(
            color: selected ? AppColor.inkDark : AppColor.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
