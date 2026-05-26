import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepPlaces extends StatelessWidget {
  final TripPlanningController controller;
  const StepPlaces({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text('Select places to visit', style: AppTextStyle.heading3),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Obx(() => Text(
                '${controller.selectedPlaces.length}/${TripPlanningController.maxPlacesPerDay} selected · ${controller.estimatedDuration}',
                style: AppTextStyle.labelSmall.copyWith(color: AppColor.primary),
              )),
        ),
        Expanded(
          child: Obx(() {
            if (controller.selectedDistrict.value == null) {
              return Center(
                child: Text('Select a district first',
                    style: AppTextStyle.bodySmall),
              );
            }
            if (controller.isLoadingPlaces.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              );
            }
            if (controller.placesError.value.isNotEmpty &&
                controller.districtPlaces.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    controller.placesError.value,
                    style: AppTextStyle.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (controller.districtPlaces.isEmpty) {
              return Center(
                child: Text(
                  'No places found for ${controller.selectedDistrict.value!.name}',
                  style: AppTextStyle.bodySmall,
                  textAlign: TextAlign.center,
                ),
              );
            }
            final places = controller.districtPlaces;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: places.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final place = places[i];
                return Obx(() => _PlaceTile(
                      controller: controller,
                      place: place,
                    ));
              },
            );
          }),
        ),
      ],
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final TripPlanningController controller;
  final PlaceModel place;

  const _PlaceTile({required this.controller, required this.place});

  @override
  Widget build(BuildContext context) {
    final selected = controller.isPlaceSelected(place);
    return GestureDetector(
      onTap: () => controller.togglePlace(place),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColor.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColor.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: place.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: place.images.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(width: 80, height: 80, color: AppColor.border),
                    )
                  : Container(width: 80, height: 80, color: AppColor.border),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
                      style: AppTextStyle.sectionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(place.visitDuration,
                      style: AppTextStyle.labelSmall.copyWith(
                          color: AppColor.textSecondary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 13, color: AppColor.accent),
                      const SizedBox(width: 2),
                      Text(place.rating.toStringAsFixed(1),
                          style: AppTextStyle.labelSmall),
                      const SizedBox(width: 8),
                      if (place.isFreeEntry)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Free',
                              style: AppTextStyle.labelSmall.copyWith(
                                  color: AppColor.primary, fontSize: 10)),
                        )
                      else
                        Text('৳${place.entryFee.toInt()}',
                            style: AppTextStyle.labelSmall),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selected ? AppColor.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColor.primary : AppColor.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 14, color: AppColor.inkDark)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
