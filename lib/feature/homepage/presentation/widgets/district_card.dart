import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';

class DistrictCard extends StatelessWidget {
  final DistrictModel district;
  final VoidCallback onTap;

  const DistrictCard({super.key, required this.district, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'district_${district.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Cover image
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: district.coverImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: district.coverImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Shimmer.fromColors(
                          baseColor: AppColor.shimmerBase,
                          highlightColor: AppColor.shimmerHighlight,
                          child: Container(color: AppColor.shimmerBase),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColor.bgCard,
                          child: const Icon(Icons.landscape_rounded,
                              color: AppColor.textSecondary, size: 48),
                        ),
                      )
                    : Container(
                        color: AppColor.bgCard,
                        child: const Icon(Icons.landscape_rounded,
                            color: AppColor.textSecondary, size: 48),
                      ),
              ),
              // Gradient overlay
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
              // Text content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          MyApp.isEnglish.value
                              ? district.name
                              : district.nameBn,
                          style: AppTextStyle.sectionTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${district.placeCount} places',
                        style: AppTextStyle.caption
                            .copyWith(color: AppColor.inkDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
