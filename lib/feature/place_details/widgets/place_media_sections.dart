import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/core/utils/video_url_utils.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/place_details/place_details_controller.dart';
import 'package:cholo_bd/feature/place_details/widgets/place_video_player_sheet.dart';

/// Hero image carousel for the place details app bar.
class PlaceDetailsImageCarousel extends StatelessWidget {
  final PlaceModel place;
  final PlaceDetailsController controller;

  const PlaceDetailsImageCarousel({
    super.key,
    required this.place,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (place.images.isEmpty) {
      return Container(color: AppColor.bgCard);
    }

    if (place.images.length == 1) {
      return CachedNetworkImage(
        imageUrl: place.images.first,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Container(color: AppColor.bgCard),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: place.images.length,
          onPageChanged: controller.onImageChanged,
          itemBuilder: (_, index) => CachedNetworkImage(
            imageUrl: place.images[index],
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(color: AppColor.bgCard),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                place.images.length,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentImageIndex.value == i
                        ? AppColor.primary
                        : Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal gallery of additional images below the hero.
class PlacePhotosSection extends StatelessWidget {
  final PlaceModel place;

  const PlacePhotosSection({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    if (place.images.length <= 1) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos', style: AppTextStyle.sectionTitle),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: place.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: CachedNetworkImage(
                  imageUrl: place.images[index],
                  fit: BoxFit.cover,
                  width: 130,
                  errorWidget: (_, __, ___) =>
                      Container(color: AppColor.bgCardLight),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Horizontal list of place videos (YouTube or direct URLs).
class PlaceVideosSection extends StatelessWidget {
  final PlaceModel place;

  const PlaceVideosSection({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    if (place.videos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Videos', style: AppTextStyle.sectionTitle),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: place.videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final url = place.videos[index];
              final isYoutube = VideoUrlUtils.isYouTube(url);
              final thumb = VideoUrlUtils.youtubeThumbnail(url);

              return GestureDetector(
                onTap: () => openPlaceVideo(
                  context,
                  url,
                  '${place.name} — Video ${index + 1}',
                ),
                child: SizedBox(
                  width: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (thumb != null)
                          CachedNetworkImage(
                            imageUrl: thumb,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _videoPlaceholder(),
                          )
                        else
                          _videoPlaceholder(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: Row(
                            children: [
                              Icon(
                                isYoutube
                                    ? Icons.play_circle_outline_rounded
                                    : Icons.videocam_rounded,
                                color: AppColor.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  isYoutube
                                      ? 'Watch on YouTube'
                                      : 'Play video',
                                  style: AppTextStyle.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _videoPlaceholder() {
    return Container(
      color: AppColor.bgCardLight,
      alignment: Alignment.center,
      child: const Icon(
        Icons.movie_rounded,
        color: AppColor.textSecondary,
        size: 40,
      ),
    );
  }
}
