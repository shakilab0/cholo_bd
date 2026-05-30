import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/category_places/category_places_controller.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class CategoryPlacesPage extends GetView<CategoryPlacesController> {
  const CategoryPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColor.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
              children: [
              
                Text(controller.category.title, style: AppTextStyle.heading3),
              ],
            ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }
        if (controller.places.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(controller.category.icon,
                      size: 56,
                      color: AppColor.textSecondary.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text('No places found',
                      style: AppTextStyle.sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Try exploring districts on the home screen.',
                    style: AppTextStyle.bodySmall
                        .copyWith(color: AppColor.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: controller.places.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _PlaceCard(
            place: controller.places[i],
            onTap: () => controller.navigateToPlaceDetails(controller.places[i]),
          ),
        );
      }),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;

  const _PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'place_${place.id}',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: place.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: place.images.first,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              Container(color: AppColor.bgCardLight),
                        )
                      : Container(color: AppColor.bgCardLight),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(place.name,
                            style: AppTextStyle.sectionTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (place.isFreeEntry)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Free',
                              style: AppTextStyle.caption.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w700)),
                        )
                      else
                        Text('৳${place.entryFee.toInt()}',
                            style: AppTextStyle.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(place.districtName,
                      style: AppTextStyle.caption
                          .copyWith(color: AppColor.primary)),
                  const SizedBox(height: 4),
                  Text(place.description,
                      style: AppTextStyle.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColor.accent, size: 14),
                      const SizedBox(width: 3),
                      Text(place.rating.toStringAsFixed(1),
                          style: AppTextStyle.labelSmall.copyWith(
                              color: AppColor.textPrimary,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: AppColor.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
