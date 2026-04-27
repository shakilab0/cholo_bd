import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trips/trips_controller.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripsController>();
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        title: Text('My Trips', style: AppTextStyle.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColor.primary),
            onPressed: controller.startNewTrip,
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColor.primary));
              }
              final trips = controller.filteredTrips;
              if (trips.isEmpty) {
                return _EmptyState(controller: controller);
              }
              return RefreshIndicator(
                color: AppColor.primary,
                backgroundColor: AppColor.bgCard,
                onRefresh: controller.loadTrips,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: trips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _TripCard(trip: trips[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final TripsController controller;
  const _FilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedFilter.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Row(
          children: [
            _FilterChip(
              label: 'Upcoming',
              selected: selected == 'upcoming',
              onTap: () => controller.setFilter('upcoming'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'All',
              selected: selected == 'all',
              onTap: () => controller.setFilter('all'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Completed',
              selected: selected == 'completed',
              onTap: () => controller.setFilter('completed'),
            ),
          ],
        ),
      );
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
}

class _TripCard extends StatelessWidget {
  final TripModel trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final statusColor = trip.status == TripStatus.upcoming
        ? AppColor.primary
        : trip.status == TripStatus.active
            ? AppColor.accent
            : AppColor.textSecondary;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.tripDetails, arguments: trip),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(trip.name,
                    style: AppTextStyle.sectionTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trip.status.name[0].toUpperCase() +
                      trip.status.name.substring(1),
                  style: AppTextStyle.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetaItem(
                icon: Icons.location_on_rounded,
                text: trip.districtName,
              ),
              const SizedBox(width: 16),
              _MetaItem(
                icon: Icons.event_rounded,
                text: DateFormat('d MMM yyyy').format(trip.tripDate),
              ),
              const SizedBox(width: 16),
              _MetaItem(
                icon: Icons.place_rounded,
                text: '${trip.places.length} place${trip.places.length == 1 ? '' : 's'}',
              ),
            ],
          ),
          if (trip.places.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColor.border, height: 1),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: trip.places
                  .take(3)
                  .map((p) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColor.bgCardLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(p.name,
                            style: AppTextStyle.labelSmall.copyWith(
                                fontSize: 10,
                                color: AppColor.textSecondary)),
                      ))
                  .toList()
                ..addAll(trip.places.length > 3
                    ? [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('+${trip.places.length - 3} more',
                              style: AppTextStyle.labelSmall.copyWith(
                                  fontSize: 10, color: AppColor.primary)),
                        )
                      ]
                    : []),
            ),
          ],
        ],
      ),
    ));
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColor.textSecondary),
        const SizedBox(width: 4),
        Text(text,
            style: AppTextStyle.labelSmall
                .copyWith(color: AppColor.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TripsController controller;
  const _EmptyState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined,
                size: 64,
                color: AppColor.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text('No trips yet', style: AppTextStyle.sectionTitle),
            const SizedBox(height: 8),
            Text(
              'Plan your first adventure in Bangladesh',
              style: AppTextStyle.labelSmall
                  .copyWith(color: AppColor.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.startNewTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.inkDark,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text('Plan a Trip',
                  style: AppTextStyle.sectionTitle
                      .copyWith(color: AppColor.inkDark)),
            ),
          ],
        ),
      ),
    );
  }
}
