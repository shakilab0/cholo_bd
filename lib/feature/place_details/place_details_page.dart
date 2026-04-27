import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/place_details/place_details_controller.dart';

class PlaceDetailsPage extends StatelessWidget {
  const PlaceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlaceDetailsController>();
    final place = controller.place;

    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColor.bgDark,
            leading: GestureDetector(
              onTap: Get.back,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
            actions: [
              Obx(() => GestureDetector(
                    onTap: controller.toggleSave,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.isSaved.value
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: controller.isSaved.value
                            ? AppColor.primary
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  )),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'place_${place.id}',
                child: place.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: place.images.first,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            Container(color: AppColor.bgCard),
                      )
                    : Container(color: AppColor.bgCard),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.name, style: AppTextStyle.heading3),
                            if (place.nameBn.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(place.nameBn,
                                  style: AppTextStyle.labelSmall.copyWith(
                                      color: AppColor.textSecondary)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColor.accent, size: 16),
                              const SizedBox(width: 4),
                              Text(place.rating.toStringAsFixed(1),
                                  style: AppTextStyle.sectionTitle),
                            ],
                          ),
                          Text('${place.reviewCount} reviews',
                              style: AppTextStyle.labelSmall.copyWith(
                                  color: AppColor.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: place.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColor.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColor.primary.withValues(alpha: 0.3)),
                              ),
                              child: Text(tag,
                                  style: AppTextStyle.labelSmall.copyWith(
                                      color: AppColor.primary)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _InfoGrid(place: place),
                  const SizedBox(height: 20),
                  Text('About', style: AppTextStyle.sectionTitle),
                  const SizedBox(height: 8),
                  Text(place.description,
                      style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textSecondary, height: 1.6)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: AppColor.bgCard,
          border: Border(top: BorderSide(color: AppColor.border)),
        ),
        child: ElevatedButton.icon(
          onPressed: controller.planTripHere,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.inkDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_location_alt_rounded, size: 20),
          label: Text('Plan a Trip Here',
              style: AppTextStyle.sectionTitle.copyWith(color: AppColor.inkDark)),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final dynamic place;
  const _InfoGrid({required this.place});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.6,
      children: [
        _InfoTile(
          icon: Icons.schedule_rounded,
          label: 'Visit Duration',
          value: place.visitDuration,
        ),
        _InfoTile(
          icon: Icons.wb_sunny_rounded,
          label: 'Best Time',
          value: place.bestTime,
        ),
        _InfoTile(
          icon: Icons.access_time_rounded,
          label: 'Opening Hours',
          value: place.openingHours,
        ),
        _InfoTile(
          icon: Icons.payments_rounded,
          label: 'Entry Fee',
          value: place.isFreeEntry ? 'Free' : '৳${place.entryFee.toInt()}',
          valueColor: place.isFreeEntry ? AppColor.primary : null,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: AppTextStyle.labelSmall.copyWith(
                        color: AppColor.textSecondary, fontSize: 9),
                    maxLines: 1),
                Text(value,
                    style: AppTextStyle.labelSmall.copyWith(
                        color: valueColor ?? AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
