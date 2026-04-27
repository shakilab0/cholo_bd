import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/transport_option_model.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepTransport extends StatelessWidget {
  final TripPlanningController controller;
  const StepTransport({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('How will you travel?', style: AppTextStyle.heading3),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Choose your primary mode of transport',
            style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bangladeshTransports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final transport = bangladeshTransports[i];
              return Obx(() {
                final selected = controller.selectedTransport.value?.id == transport.id;
                return GestureDetector(
                  onTap: () => controller.selectTransport(transport),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColor.primary.withValues(alpha: 0.12)
                          : AppColor.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? AppColor.primary : AppColor.border,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColor.primary.withValues(alpha: 0.2)
                                : AppColor.bgCardLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            transport.icon,
                            color: selected ? AppColor.primary : AppColor.textSecondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(transport.name, style: AppTextStyle.sectionTitle),
                                  const SizedBox(width: 6),
                                  Text(transport.nameBn,
                                      style: AppTextStyle.labelSmall.copyWith(
                                          color: AppColor.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(transport.description,
                                  style: AppTextStyle.labelSmall.copyWith(
                                      color: AppColor.textSecondary),
                                  maxLines: 1),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _InfoPill(
                                      icon: Icons.schedule_rounded,
                                      text: transport.estimatedTime),
                                  const SizedBox(width: 8),
                                  _InfoPill(
                                      icon: Icons.payments_rounded,
                                      text: transport.estimatedCost),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: selected ? AppColor.primary : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? AppColor.primary : AppColor.border,
                              width: 2,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check, size: 13, color: AppColor.inkDark)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColor.textSecondary),
        const SizedBox(width: 3),
        Text(text,
            style: AppTextStyle.labelSmall.copyWith(
                color: AppColor.textSecondary, fontSize: 10)),
      ],
    );
  }
}
