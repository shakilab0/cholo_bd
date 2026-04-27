import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/trip_details/trip_details_controller.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/core/routes/routes.dart';

class TripDetailsPage extends StatelessWidget {
  const TripDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TripDetailsController>();
    final trip = c.trip;

    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
        title: Text('Trip Details', style: AppTextStyle.sectionTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColor.primary),
            onPressed: c.shareTrip,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TripHeaderCard(trip: trip, statusLabel: c.statusLabel),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Itinerary',
                  style: AppTextStyle.sectionTitle),
            ),
            const SizedBox(height: 12),
            _ItineraryTimeline(places: trip.places),
            const SizedBox(height: 24),
            _TransportCard(trip: trip),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActions(trip: trip),
    );
  }
}

class _TripHeaderCard extends StatelessWidget {
  final TripModel trip;
  final String statusLabel;
  const _TripHeaderCard({required this.trip, required this.statusLabel});

  @override
  Widget build(BuildContext context) {
    final statusColor = trip.status == TripStatus.upcoming
        ? AppColor.primary
        : trip.status == TripStatus.active
            ? AppColor.accent
            : AppColor.textSecondary;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(trip.name, style: AppTextStyle.heading3),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusLabel,
                    style: AppTextStyle.caption.copyWith(
                        color: statusColor, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColor.border, height: 1),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: 'District',
            value: trip.districtName,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.event_rounded,
            label: 'Date',
            value: DateFormat('EEEE, d MMMM yyyy').format(trip.tripDate),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.place_rounded,
            label: 'Places',
            value:
                '${trip.places.length} place${trip.places.length == 1 ? '' : 's'}',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColor.primary, size: 18),
        const SizedBox(width: 10),
        Text(label,
            style: AppTextStyle.labelSmall
                .copyWith(color: AppColor.textSecondary)),
        const Spacer(),
        Text(value,
            style: AppTextStyle.labelSmall
                .copyWith(color: AppColor.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ItineraryTimeline extends StatelessWidget {
  final List<PlaceModel> places;
  const _ItineraryTimeline({required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text('No places added.',
              style: TextStyle(color: AppColor.textSecondary)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(places.length, (i) {
          final place = places[i];
          final isLast = i == places.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline column
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColor.primary, width: 1.5),
                        ),
                        child: Center(
                          child: Text('${i + 1}',
                              style: AppTextStyle.caption.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: AppColor.border,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Place card
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(place.name, style: AppTextStyle.sectionTitle),
                        if (place.nameBn.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(place.nameBn,
                              style: AppTextStyle.caption.copyWith(
                                  color: AppColor.textSecondary)),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded,
                                size: 12, color: AppColor.textSecondary),
                            const SizedBox(width: 4),
                            Text(place.visitDuration,
                                style: AppTextStyle.caption),
                            const SizedBox(width: 12),
                            const Icon(Icons.payments_rounded,
                                size: 12, color: AppColor.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                                place.isFreeEntry
                                    ? 'Free'
                                    : '৳${place.entryFee.toInt()}',
                                style: AppTextStyle.caption.copyWith(
                                    color: place.isFreeEntry
                                        ? AppColor.primary
                                        : null)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  final TripModel trip;
  const _TransportCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final transport = trip.transport;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(transport.icon, color: AppColor.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transport.name, style: AppTextStyle.sectionTitle),
                Text(transport.description,
                    style: AppTextStyle.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transport.estimatedTime,
                  style: AppTextStyle.caption.copyWith(
                      color: AppColor.textSecondary)),
              Text(transport.estimatedCost,
                  style: AppTextStyle.labelSmall.copyWith(
                      color: AppColor.primary, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final TripModel trip;
  const _BottomActions({required this.trip});

  @override
  Widget build(BuildContext context) {
    if (trip.status == TripStatus.completed) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColor.bgCard,
        border: Border(top: BorderSide(color: AppColor.border)),
      ),
      child: ElevatedButton.icon(
        onPressed: () =>
            Get.toNamed(AppRoutes.activeTrip, arguments: trip),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.inkDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.play_circle_rounded, size: 20),
        label: Text(
          trip.status == TripStatus.active ? 'Continue Trip' : 'Start Trip',
          style: AppTextStyle.sectionTitle.copyWith(color: AppColor.inkDark),
        ),
      ),
    );
  }
}
