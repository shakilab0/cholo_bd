import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class FeaturedSlider extends StatelessWidget {
  final List<PlaceModel> places;
  final void Function(PlaceModel) onTap;

  const FeaturedSlider({super.key, required this.places, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) return const SizedBox.shrink();
    return CarouselSlider.builder(
      itemCount: places.length,
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 0.92,
        enlargeCenterPage: true,
      ),
      itemBuilder: (_, index, __) {
        final place = places[index];
        return GestureDetector(
          onTap: () => onTap(place),
          child: Hero(
            tag: 'place_${place.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: place.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: place.images.first,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: AppColor.shimmerBase,
                              highlightColor: AppColor.shimmerHighlight,
                              child: Container(color: AppColor.shimmerBase),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppColor.bgCard,
                              child: const Icon(Icons.photo_rounded,
                                  color: AppColor.textSecondary, size: 48),
                            ),
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
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              MyApp.isEnglish.value ? place.name : place.nameBn,
                              style: AppTextStyle.heading3,
                            )),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColor.accent, size: 14),
                            const SizedBox(width: 4),
                            Text(place.rating.toStringAsFixed(1),
                                style: AppTextStyle.caption
                                    .copyWith(color: AppColor.accent)),
                            const SizedBox(width: 8),
                            if (place.isFreeEntry)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Free',
                                    style: AppTextStyle.caption.copyWith(
                                        color: AppColor.inkDark,
                                        fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
