import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/district_places/district_places_controller.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class DistrictPlacesPage extends StatelessWidget {
  const DistrictPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DistrictPlacesController>();
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: CustomScrollView(
        slivers: [
          _districtHeroAppBar(controller: c, context: context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _filterBar(controller: c, context: context),
                _placesList(controller: c),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _planTripBar(controller: c, context: context),
    );
  }

  Widget _districtHeroAppBar({required BuildContext context,required DistrictPlacesController controller}) {
    final district = controller.district;
    return SliverAppBar(
      expandedHeight: 240,
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
      flexibleSpace: FlexibleSpaceBar(
        title: Text(district.name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        titlePadding: const EdgeInsets.only(left: 30, bottom: 16),
        background: Hero(
          tag: 'district_${district.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              district.coverImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: district.coverImageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(color: AppColor.bgCard),
              )
                  : Container(color: AppColor.bgCard),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterBar({required BuildContext context,required DistrictPlacesController controller}) {
     const _filters = [
      ('all', 'All'),
      ('popular', 'Popular'),
      ('top_rated', 'Top Rated'),
      ('free', 'Free Entry'),
    ];
    return Obx(() {
      final active = controller.activeFilter.value;
      return SizedBox(
        height: 52,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: _filters
              .map((f) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _filterChip(
              label: f.$2,
              selected: active == f.$1,
              onTap: () => controller.setFilter(f.$1),
            ),
          ))
              .toList(),
        ),
      );
    });
  }

  Widget _filterChip({ required String label, required bool selected,required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColor.primary : AppColor.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppColor.primary : AppColor.border),
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

  Widget _placesList({required DistrictPlacesController controller}) {
    return Obx(() {
      if (controller.isLoadingPlaces.value) {
        return const Padding(
          padding: EdgeInsets.all(48),
          child: Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          ),
        );
      }

      final places = controller.filteredPlaces;
      if (places.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(48),
          child: Center(
            child: Text('No places found for this filter.',
                style: TextStyle(color: AppColor.textSecondary)),
          ),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: places.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) =>
            _placeCard(place: places[i], controller: controller),
      );
    });
  }

  Widget _placeCard({required PlaceModel  place, required DistrictPlacesController controller}) {
    return GestureDetector(
      onTap: () => controller.navigateToPlaceDetails(place),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
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
                      Text(' (${place.reviewCount})',
                          style: AppTextStyle.caption),
                      const SizedBox(width: 12),
                      const Icon(Icons.schedule_rounded,
                          size: 13, color: AppColor.textSecondary),
                      const SizedBox(width: 3),
                      Text(place.visitDuration,
                          style: AppTextStyle.caption),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: AppColor.textSecondary),
                    ],
                  ),
                  if (place.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: place.tags
                          .take(3)
                          .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColor.bgCardLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('#$t',
                            style: AppTextStyle.caption.copyWith(
                                color: AppColor.textSecondary)),
                      ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planTripBar({required BuildContext context,required DistrictPlacesController controller}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColor.bgCard,
        border: Border(top: BorderSide(color: AppColor.border)),
      ),
      child: Obx(() {
        final count = controller.allPlaces.length;
        return ElevatedButton.icon(
          onPressed: controller.startTripHere,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.inkDark,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.map_outlined, size: 20),
          label: Text(
            'Plan a Trip to ${controller.district.name} ($count places)',
            style:
            AppTextStyle.sectionTitle.copyWith(color: AppColor.inkDark),
          ),
        );
      }),
    );
  }
  
}
