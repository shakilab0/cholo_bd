import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepConfirm extends StatefulWidget {
  final TripPlanningController controller;
  const StepConfirm({super.key, required this.controller});

  @override
  State<StepConfirm> createState() => _StepConfirmState();
}

class _StepConfirmState extends State<StepConfirm> {
  late final TextEditingController _tripNameCtrl;

  TripPlanningController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    final district = controller.selectedDistrict.value;
    _tripNameCtrl = TextEditingController(
      text: district != null ? 'Trip to ${district.name}' : '',
    );
    controller.tripName.value = _tripNameCtrl.text;
    _tripNameCtrl.addListener(() {
      controller.tripName.value = _tripNameCtrl.text;
    });
  }

  @override
  void dispose() {
    _tripNameCtrl.dispose();
    super.dispose();
  }

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
          _tripNameField(),
          const SizedBox(height: 16),
          _summaryCard(),
          const SizedBox(height: 16),
          _placesList(),
        ],
      ),
    );
  }

  Widget _tripNameField() {
    return TextField(
      controller: _tripNameCtrl,
      style: AppTextStyle.sectionTitle,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: 'Trip name',
        labelStyle:
            AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
        counterStyle:
            AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
        prefixIcon:
            const Icon(Icons.edit_rounded, color: AppColor.primary, size: 18),
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

  Widget _summaryCard() {
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
            _summaryRow(
              icon: Icons.location_on_rounded,
              label: 'District',
              value: district?.name ?? '—',
            ),
            if (controller.startLocationLabel.value.isNotEmpty) ...[
              _divider(),
              _summaryRow(
                icon: Icons.my_location_rounded,
                label: 'Start',
                value: controller.startLocationLabel.value,
              ),
            ],
            if (controller.selectedPlaces.isNotEmpty) ...[
              _divider(),
              _summaryRow(
                icon: Icons.flag_rounded,
                label: 'Destination',
                value: controller.destinationPlaceName,
              ),
            ],
            _divider(),
            _summaryRow(
              icon: Icons.place_rounded,
              label: 'Places',
              value:
                  '${places.length} place${places.length == 1 ? '' : 's'} · ${controller.estimatedDuration}',
            ),
            _divider(),
            _summaryRow(
              icon: Icons.event_rounded,
              label: 'Date',
              value: DateFormat('EEE, d MMM yyyy').format(date),
            ),
            _divider(),
            _summaryRow(
              icon: Icons.schedule_rounded,
              label: 'Start time',
              value: controller.startTimeLabel,
            ),
            _divider(),
            _summaryRow(
              icon: transport?.icon ?? Icons.directions_bus_rounded,
              label: 'Transport',
              value: transport != null
                  ? '${transport.name} · ${controller.timeLabelFor(transport)}'
                  : '—',
            ),
          ],
        ),
      );
    });
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColor.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTextStyle.labelSmall
                .copyWith(color: AppColor.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyle.labelSmall.copyWith(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(color: AppColor.border, height: 1);
  }

  Widget _placesList() {
    return Obx(() {
      final places = controller.selectedPlaces;
      if (places.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Itinerary',
            style:
                AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
          ),
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
                      child: Text(
                        '${idx + 1}',
                        style: AppTextStyle.labelSmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      place.name,
                      style: AppTextStyle.sectionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    place.visitDuration,
                    style: AppTextStyle.labelSmall
                        .copyWith(color: AppColor.textSecondary),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }
}
