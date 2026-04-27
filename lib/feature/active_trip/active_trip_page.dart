import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/active_trip/active_trip_controller.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class ActiveTripPage extends StatelessWidget {
  const ActiveTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ActiveTripController>();
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
        title: Text('Active Trip', style: AppTextStyle.sectionTitle),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _confirmEndTrip(context, c),
            child: Text('End Trip',
                style: AppTextStyle.labelSmall
                    .copyWith(color: AppColor.alertRed)),
          ),
        ],
      ),
      body: Column(
        children: [
          _ProgressHeader(controller: c),
          Expanded(child: _PlaceChecklist(controller: c)),
        ],
      ),
    );
  }

  void _confirmEndTrip(BuildContext context, ActiveTripController c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColor.border,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text('End Trip?', style: AppTextStyle.heading3),
            const SizedBox(height: 8),
            Obx(() => Text(
                  'You visited ${c.visitedCount} of ${c.totalPlaces} places.',
                  style: AppTextStyle.bodySmall,
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: Get.back,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.textPrimary,
                      side: const BorderSide(color: AppColor.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      c.endTrip();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.alertRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('End Trip'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final ActiveTripController controller;
  const _ProgressHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final progress = controller.progress;
      final visited = controller.visitedCount;
      final total = controller.totalPlaces;

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primary.withValues(alpha: 0.2),
              AppColor.primary.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.primary.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    color: AppColor.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.trip.districtName,
                    style: AppTextStyle.heading3,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$visited / $total places',
                    style: AppTextStyle.labelSmall.copyWith(
                        color: AppColor.primary, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              controller.trip.name,
              style: AppTextStyle.bodySmall,
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColor.border,
                color: AppColor.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              progress == 1.0
                  ? '🎉 All places visited!'
                  : '${((1 - progress) * controller.totalPlaces).ceil()} place${((1 - progress) * controller.totalPlaces).ceil() == 1 ? '' : 's'} remaining',
              style: AppTextStyle.caption
                  .copyWith(color: AppColor.primary),
            ),
          ],
        ),
      );
    });
  }
}

class _PlaceChecklist extends StatelessWidget {
  final ActiveTripController controller;
  const _PlaceChecklist({required this.controller});

  @override
  Widget build(BuildContext context) {
    final places = controller.trip.places;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: places.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) =>
          _PlaceCheckTile(place: places[i], controller: controller, index: i),
    );
  }
}

class _PlaceCheckTile extends StatelessWidget {
  final PlaceModel place;
  final ActiveTripController controller;
  final int index;
  const _PlaceCheckTile(
      {required this.place, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final visited = controller.isVisited(place);
      return GestureDetector(
        onTap: () => controller.markVisited(place),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: visited
                ? AppColor.primary.withValues(alpha: 0.1)
                : AppColor.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: visited ? AppColor.primary : AppColor.border,
              width: visited ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Step number / check circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: visited ? AppColor.primary : AppColor.bgCardLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: visited ? AppColor.primary : AppColor.border,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: visited
                      ? const Icon(Icons.check_rounded,
                          color: AppColor.inkDark, size: 18)
                      : Text('${index + 1}',
                          style: AppTextStyle.labelSmall.copyWith(
                              color: AppColor.textSecondary,
                              fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: AppTextStyle.sectionTitle.copyWith(
                        decoration:
                            visited ? TextDecoration.lineThrough : null,
                        color: visited
                            ? AppColor.textSecondary
                            : AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 12, color: AppColor.textSecondary),
                        const SizedBox(width: 3),
                        Text(place.visitDuration,
                            style: AppTextStyle.caption),
                        const SizedBox(width: 10),
                        Icon(Icons.payments_rounded,
                            size: 12, color: AppColor.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          place.isFreeEntry
                              ? 'Free'
                              : '৳${place.entryFee.toInt()}',
                          style: AppTextStyle.caption.copyWith(
                            color: place.isFreeEntry
                                ? AppColor.primary
                                : AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                visited ? 'Visited ✓' : 'Tap to mark',
                style: AppTextStyle.caption.copyWith(
                  color: visited ? AppColor.primary : AppColor.textSecondary,
                  fontWeight:
                      visited ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
