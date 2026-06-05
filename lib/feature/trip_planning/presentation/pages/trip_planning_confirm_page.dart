import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/widgets/step_confirm.dart';

class TripPlanningConfirmPage extends GetView<TripPlanningController> {
  const TripPlanningConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text('Plan a Trip', style: AppTextStyle.sectionTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(child: StepConfirm(controller: controller)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    TripPlanningController.totalSteps,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == 4 ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == 4 ? AppColor.primary : AppColor.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _confirmButton(context),
        ],
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColor.bgCard,
        border: Border(top: BorderSide(color: AppColor.border)),
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed:
              controller.isCreating.value ? null : controller.confirmTrip,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.inkDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            disabledBackgroundColor: AppColor.primary.withValues(alpha: 0.5),
          ),
          child: Text(
            controller.isCreating.value ? 'Saving...' : 'Confirm Trip',
            style: AppTextStyle.sectionTitle.copyWith(color: AppColor.inkDark),
          ),
        ),
      ),
    );
  }
}
