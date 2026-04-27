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

  static final List<PlaceModel> _samplePlaces = [
    const PlaceModel(
      id: 'p_cox_1',
      name: "Laboni Beach",
      nameBn: "লাবণী বিচ",
      description: "Most accessible beach in Cox's Bazar",
      districtId: 'coxs_bazar',
      districtName: "Cox's Bazar",
      images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Laboni_beach_01.JPG/1280px-Laboni_beach_01.JPG'],
      entryFee: 0,
      isFreeEntry: true,
      visitDuration: '2-3 hours',
      bestTime: 'October - March',
      openingHours: 'Open daily',
      latitude: 21.4272,
      longitude: 92.0058,
      rating: 4.5,
      reviewCount: 1200,
      tags: ['beach', 'sunset', 'popular'],
    ),
    const PlaceModel(
      id: 'p_cox_2',
      name: "Himchari",
      nameBn: "হিমছড়ি",
      description: "Scenic waterfall and hilltop viewpoint",
      districtId: 'coxs_bazar',
      districtName: "Cox's Bazar",
      images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Himchari_Waterfall.jpg/1280px-Himchari_Waterfall.jpg'],
      entryFee: 50,
      isFreeEntry: false,
      visitDuration: '3-4 hours',
      bestTime: 'July - September',
      openingHours: '8 AM - 5 PM',
      latitude: 21.3500,
      longitude: 91.9833,
      rating: 4.3,
      reviewCount: 850,
      tags: ['waterfall', 'nature', 'hiking'],
    ),
    const PlaceModel(
      id: 'p_cox_3',
      name: "Inani Beach",
      nameBn: "ইনানী বিচ",
      description: "Pristine beach with coral rocks",
      districtId: 'coxs_bazar',
      districtName: "Cox's Bazar",
      images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Inani_beach.jpg/1280px-Inani_beach.jpg'],
      entryFee: 0,
      isFreeEntry: true,
      visitDuration: '2-3 hours',
      bestTime: 'November - February',
      openingHours: 'Open daily',
      latitude: 21.3000,
      longitude: 91.9667,
      rating: 4.7,
      reviewCount: 980,
      tags: ['beach', 'coral', 'scenic'],
    ),
    const PlaceModel(
      id: 'p_syl_1',
      name: "Ratargul Swamp Forest",
      nameBn: "রাতারগুল সোয়াম্প ফরেস্ট",
      description: "Bangladesh's only freshwater swamp forest",
      districtId: 'sylhet',
      districtName: "Sylhet",
      images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Ratargul_Swamp_Forest.jpg/1280px-Ratargul_Swamp_Forest.jpg'],
      entryFee: 100,
      isFreeEntry: false,
      visitDuration: '3-5 hours',
      bestTime: 'June - October',
      openingHours: '7 AM - 5 PM',
      latitude: 25.0000,
      longitude: 91.9167,
      rating: 4.8,
      reviewCount: 1500,
      tags: ['forest', 'boat', 'nature'],
    ),
    const PlaceModel(
      id: 'p_syl_2',
      name: "Jaflong",
      nameBn: "জাফলং",
      description: "Stone collection point at Piyain River",
      districtId: 'sylhet',
      districtName: "Sylhet",
      images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Jaflong_-_Sylhet.jpg/1280px-Jaflong_-_Sylhet.jpg'],
      entryFee: 20,
      isFreeEntry: false,
      visitDuration: '2-3 hours',
      bestTime: 'October - March',
      openingHours: 'Open daily',
      latitude: 25.1500,
      longitude: 91.8833,
      rating: 4.4,
      reviewCount: 1100,
      tags: ['river', 'scenic', 'stones'],
    ),
  ];

  List<PlaceModel> get _filteredPlaces {
    final districtId = controller.selectedDistrict.value?.id ?? '';
    final filtered = _samplePlaces.where((p) => p.districtId == districtId).toList();
    return filtered.isNotEmpty ? filtered : _samplePlaces;
  }

  @override
  Widget build(BuildContext context) {
    final places = _filteredPlaces;
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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final place = places[i];
              return Obx(() {
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
                                              color: AppColor.primary,
                                              fontSize: 10)),
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
                                ? const Icon(Icons.check,
                                    size: 14, color: AppColor.inkDark)
                                : null,
                          ),
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
