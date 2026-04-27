import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
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
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: seedDistricts.length,
            itemBuilder: (_, i) {
              final district = seedDistricts[i];
              return Obx(() {
                final selected =
                    controller.selectedDistrict.value?.id == district.id;
                return GestureDetector(
                  onTap: () => controller.selectDistrict(district),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? AppColor.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: district.coverImageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: district.coverImageUrl,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(
                                        color: AppColor.bgCard),
                                  )
                                : Container(color: AppColor.bgCard),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColor.cardGradientStart,
                                    AppColor.cardGradientEnd,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (selected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColor.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: AppColor.inkDark, size: 14),
                              ),
                            ),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 10,
                            child: Text(district.name,
                                style: AppTextStyle.sectionTitle,
                                maxLines: 1),
                          ),
                        ],
                      ),
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
