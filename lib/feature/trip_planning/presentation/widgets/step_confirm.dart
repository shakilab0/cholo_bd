import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepConfirm extends StatelessWidget {
  final TripPlanningController controller;
  const StepConfirm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('Review your trip', style: AppTextStyle.heading3),
          const SizedBox(height: 20),
          _TripNameField(controller: controller),
          const SizedBox(height: 16),
          _SummaryCard(controller: controller),
          const SizedBox(height: 16),
          _PlacesList(controller: controller),
        ],
      ),
    );
  }
}

class _TripNameField extends StatefulWidget {
  final TripPlanningController controller;
  const _TripNameField({required this.controller});

  @override
  State<_TripNameField> createState() => _TripNameFieldState();
}

class _TripNameFieldState extends State<_TripNameField> {
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    final district = widget.controller.selectedDistrict.value;
    _textCtrl = TextEditingController(
      text: district != null ? 'Trip to ${district.name}' : '',
    );
    widget.controller.tripName.value = _textCtrl.text;
    _textCtrl.addListener(() {
      widget.controller.tripName.value = _textCtrl.text;
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textCtrl,
      style: AppTextStyle.sectionTitle,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: 'Trip name',
        labelStyle: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
        counterStyle: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
        prefixIcon: const Icon(Icons.edit_rounded, color: AppColor.primary, size: 18),
        filled: true,
        fillColor: AppColor.bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary, width: 2),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final TripPlanningController controller;
  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final district = controller.selectedDistrict.value;
      final date = controller.selectedDate.value;
      final transport = controller.selectedTransport.value;
      final places = controller.selectedPlaces;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          children: [
            _SummaryRow(
              icon: Icons.location_on_rounded,
              label: 'District',
              value: district?.name ?? '—',
            ),
            const _Divider(),
            _SummaryRow(
              icon: Icons.place_rounded,
              label: 'Places',
              value: '${places.length} place${places.length == 1 ? '' : 's'} · ${controller.estimatedDuration}',
            ),
            const _Divider(),
            _SummaryRow(
              icon: Icons.event_rounded,
              label: 'Date',
              value: DateFormat('EEE, d MMM yyyy').format(date),
            ),
            const _Divider(),
            _SummaryRow(
              icon: transport?.icon ?? Icons.directions_bus_rounded,
              label: 'Transport',
              value: transport?.name ?? '—',
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColor.primary),
          const SizedBox(width: 12),
          Text(label,
              style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary)),
          const Spacer(),
          Text(value,
              style: AppTextStyle.labelSmall.copyWith(
                  color: AppColor.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColor.border, height: 1);
  }
}

class _PlacesList extends StatelessWidget {
  final TripPlanningController controller;
  const _PlacesList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final places = controller.selectedPlaces;
      if (places.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Itinerary',
              style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary)),
          const SizedBox(height: 10),
          ...places.asMap().entries.map((entry) {
            final idx = entry.key;
            final place = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${idx + 1}',
                          style: AppTextStyle.labelSmall.copyWith(
                              color: AppColor.primary,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(place.name,
                        style: AppTextStyle.sectionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(place.visitDuration,
                      style: AppTextStyle.labelSmall.copyWith(
                          color: AppColor.textSecondary)),
                ],
              ),
            );
          }),
        ],
      );
    });
  }
}
