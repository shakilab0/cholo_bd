import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/district_card.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepDistrict extends StatelessWidget {
  final TripPlanningController controller;
  const StepDistrict({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Where do you want to go?',
              style: AppTextStyle.heading3),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingDistricts.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              );
            }
            if (controller.districtsError.value.isNotEmpty &&
                controller.districts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    controller.districtsError.value,
                    style: AppTextStyle.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (controller.districts.isEmpty) {
              return Center(
                child: Text('No districts available',
                    style: AppTextStyle.bodySmall),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.93,
              ),
              itemCount: controller.districts.length,
              itemBuilder: (_, i) {
                final district = controller.districts[i];
                final selected =
                    controller.selectedDistrict.value?.id == district.id;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DistrictCard(
                        district: district,
                        isSelected: selected,
                        enableHero: false,
                        onTap: () => controller.selectDistrict(district),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(() => Text(
                          MyApp.isEnglish.value
                              ? district.name
                              : district.nameBn,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColor.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
