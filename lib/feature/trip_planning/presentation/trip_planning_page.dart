import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/planning_progress_bar.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/step_confirm.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/step_datetime.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/step_district.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/step_places.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/step_transport.dart';

class TripPlanningPage extends StatelessWidget {
  const TripPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripPlanningController>();
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: controller.previousStep,
        ),
        title: Text('Plan a Trip', style: AppTextStyle.sectionTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() => PlanningProgressBar(
                currentStep: controller.currentStep.value,
                totalSteps: TripPlanningController.totalSteps,
              )),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutCubic)),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: KeyedSubtree(
                  key: ValueKey(controller.currentStep.value),
                  child: _buildStep(controller),
                ),
              );
            }),
          ),
          _BottomBar(controller: controller),
        ],
      ),
    );
  }

  Widget _buildStep(TripPlanningController controller) {
    switch (controller.currentStep.value) {
      case 0:
        return StepDistrict(controller: controller);
      case 1:
        return StepPlaces(controller: controller);
      case 2:
        return StepDatetime(controller: controller);
      case 3:
        return StepTransport(controller: controller);
      case 4:
        return StepConfirm(controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _BottomBar extends StatelessWidget {
  final TripPlanningController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColor.bgCard,
        border: Border(top: BorderSide(color: AppColor.border)),
      ),
      child: Obx(() {
        final step = controller.currentStep.value;
        final isLast = step == TripPlanningController.totalSteps - 1;
        final canGoNext = controller.canGoNext;

        return Row(
          children: [
            if (step > 0)
              OutlinedButton(
                onPressed: controller.previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.textPrimary,
                  side: const BorderSide(color: AppColor.border),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              ),
            if (step > 0) const SizedBox(width: 12),
            Expanded(
              child: isLast
                  ? Obx(() => ElevatedButton.icon(
                        onPressed: controller.isCreating.value
                            ? null
                            : controller.confirmTrip,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.inkDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          disabledBackgroundColor:
                              AppColor.primary.withValues(alpha: 0.5),
                        ),
                        icon: controller.isCreating.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppColor.inkDark))
                            : const Icon(Icons.check_circle_rounded, size: 20),
                        label: Text(
                          controller.isCreating.value
                              ? 'Saving...'
                              : 'Confirm Trip',
                          style: AppTextStyle.sectionTitle
                              .copyWith(color: AppColor.inkDark),
                        ),
                      ))
                  : ElevatedButton(
                      onPressed: canGoNext ? controller.nextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.inkDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        disabledBackgroundColor:
                            AppColor.primary.withValues(alpha: 0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Next',
                              style: AppTextStyle.sectionTitle
                                  .copyWith(color: AppColor.inkDark)),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
