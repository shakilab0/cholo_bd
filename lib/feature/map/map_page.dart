import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/map/map_controller.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlacesMapController>();
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: Stack(
        children: [
          _MapView(controller: c),
          _TopBar(controller: c),
          _PlaceBottomSheet(controller: c),
        ],
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final PlacesMapController controller;
  const _MapView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final places = controller.filteredPlaces;
      return FlutterMap(
        options: MapOptions(
          initialCenter: PlacesMapController.bangladeshCenter,
          initialZoom: 7,
          onTap: (_, __) => controller.clearSelection(),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.cholobd.app',
          ),
          MarkerLayer(
            markers: places
                .map((place) => Marker(
                      point: LatLng(place.latitude, place.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => controller.selectPlace(place),
                        child: Obx(() {
                          final isSelected =
                              controller.selectedPlace.value?.id == place.id;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor.primary
                                  : AppColor.bgCard,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.primary,
                                width: isSelected ? 3 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.primary
                                      .withValues(alpha: isSelected ? 0.4 : 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.place_rounded,
                              color: isSelected
                                  ? AppColor.inkDark
                                  : AppColor.primary,
                              size: 20,
                            ),
                          );
                        }),
                      ),
                    ))
                .toList(),
          ),
        ],
      );
    });
  }
}

class _TopBar extends StatelessWidget {
  final PlacesMapController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColor.bgCard.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.map_rounded,
                      color: AppColor.primary, size: 18),
                  const SizedBox(width: 10),
                  Text('Explore Bangladesh',
                      style: AppTextStyle.sectionTitle),
                  const Spacer(),
                  Obx(() => Text(
                        '${controller.filteredPlaces.length} places',
                        style: AppTextStyle.caption
                            .copyWith(color: AppColor.primary),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _FilterRow(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final PlacesMapController controller;
  const _FilterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.activeFilter.value;
      return Row(
        children: [
          _FilterPill(
              label: 'All',
              selected: active == 'all',
              onTap: () => controller.setFilter('all')),
          const SizedBox(width: 8),
          _FilterPill(
              label: 'Top Rated',
              selected: active == 'top_rated',
              onTap: () => controller.setFilter('top_rated')),
          const SizedBox(width: 8),
          _FilterPill(
              label: 'Free Entry',
              selected: active == 'free',
              onTap: () => controller.setFilter('free')),
        ],
      );
    });
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterPill(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColor.primary
              : AppColor.bgCard.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppColor.primary : AppColor.border),
        ),
        child: Text(
          label,
          style: AppTextStyle.caption.copyWith(
            color: selected ? AppColor.inkDark : AppColor.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PlaceBottomSheet extends StatelessWidget {
  final PlacesMapController controller;
  const _PlaceBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final place = controller.selectedPlace.value;
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        bottom: place != null ? 0 : -220,
        left: 0,
        right: 0,
        child: place != null
            ? _PlaceCard(place: place, controller: controller)
            : const SizedBox.shrink(),
      );
    });
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final PlacesMapController controller;
  const _PlaceCard({required this.place, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(place.name, style: AppTextStyle.sectionTitle),
              ),
              GestureDetector(
                onTap: controller.clearSelection,
                child: const Icon(Icons.close_rounded,
                    color: AppColor.textSecondary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(place.districtName, style: AppTextStyle.caption),
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
              const SizedBox(width: 10),
              const Icon(Icons.schedule_rounded,
                  size: 13, color: AppColor.textSecondary),
              const SizedBox(width: 3),
              Text(place.visitDuration, style: AppTextStyle.caption),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: place.isFreeEntry
                      ? AppColor.primary.withValues(alpha: 0.15)
                      : AppColor.bgCardLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  place.isFreeEntry ? 'Free' : '৳${place.entryFee.toInt()}',
                  style: AppTextStyle.caption.copyWith(
                    color: place.isFreeEntry
                        ? AppColor.primary
                        : AppColor.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.goToPlaceDetails(place),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.inkDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('View Details',
                  style: AppTextStyle.labelSmall.copyWith(
                      color: AppColor.inkDark, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
