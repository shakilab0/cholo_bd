import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/core/services/location_service.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/sub_district_model.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepDatetime extends StatelessWidget {
  final TripPlanningController controller;
  const StepDatetime({super.key, required this.controller});

  static const _timePresets = [
    (hour: 6, minute: 0, label: '6 AM'),
    (hour: 8, minute: 0, label: '8 AM'),
    (hour: 12, minute: 0, label: '12 PM'),
    (hour: 15, minute: 0, label: '3 PM'),
    (hour: 18, minute: 0, label: '6 PM'),
    (hour: 20, minute: 0, label: '8 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('When are you going?',
            style: AppTextStyle.heading3,
          ),
          const SizedBox(height: 16),
          Obx(() {
            final selected = controller.selectedDate.value;
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = today.add(const Duration(days: 1));

            String? quickLabel;
            if (selected == today) {
              quickLabel = 'today';
            } else if (selected == tomorrow) {
              quickLabel = 'tomorrow';
            } else {
              final daysUntilSat = (6 - now.weekday) % 7;
              final offset = daysUntilSat == 0 ? 7 : daysUntilSat;
              final weekend = DateTime(now.year, now.month, now.day + offset);
              if (selected == weekend) quickLabel = 'weekend';
            }

            return Wrap(
              spacing: 10,
              children: [
                _quickChip(
                  label: 'Today',
                  selected: quickLabel == 'today',
                  onTap: () => controller.selectDateQuick(0),
                ),
                _quickChip(
                  label: 'Tomorrow',
                  selected: quickLabel == 'tomorrow',
                  onTap: () => controller.selectDateQuick(1),
                ),
                _quickChip(
                  label: 'This Weekend',
                  selected: quickLabel == 'weekend',
                  onTap: controller.selectThisWeekend,
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          _datePickerField(context: context),
          const SizedBox(height: 24),
          Text(
            'What time will you start?',
            style: AppTextStyle.heading3,
          ),
          const SizedBox(height: 6),
          Text(
            'Bus or train departure, pickup time, etc.',
            style: AppTextStyle.bodyMedium,
          ),
          const SizedBox(height: 12),
          _startTimeSection(context: context),
          const SizedBox(height: 24),
          Text(
            'Where will you start?',
            style: AppTextStyle.heading3,
          ),
          const SizedBox(height: 12),
          _startLocationCard(context: context),
        ],
      ),
    );
  }

  Widget _quickChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColor.primary : AppColor.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColor.primary : AppColor.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.labelMedium.copyWith(
            color: selected ? AppColor.inkDark : AppColor.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _openCalendar(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var picked = controller.selectedDate.value;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColor.bgCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pick a date',
                  style: AppTextStyle.heading3,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 340,
                  height: 360,
                  child: CalendarDatePicker(
                    initialDate: picked,
                    firstDate: today,
                    lastDate: today.add(const Duration(days: 365)),
                    onDateChanged: (date) => picked = date,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(
                        'Cancel',
                        style: AppTextStyle.bodyMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.selectDate(picked);
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        'Done',
                        style: AppTextStyle.labelMedium.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _datePickerField({required BuildContext context}) {
    return Obx(() {
      final selected = controller.selectedDate.value;

      return GestureDetector(
        onTap: () => _openCalendar(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.primary.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.event_rounded,
                  color: AppColor.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected date',
                      style: AppTextStyle.labelSmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy').format(selected),
                      style: AppTextStyle.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Change',
                style: AppTextStyle.labelMedium.copyWith(
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColor.primary, size: 20),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedStartTime.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: AppColor.inkDark,
              surface: AppColor.bgCard,
              onSurface: AppColor.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) controller.selectStartTime(picked);
  }

  Widget _startTimeSection({required BuildContext context}) {
    return Obx(() {
      final selected = controller.selectedStartTime.value;
      final isValid = controller.isStartTimeValid;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timePresets.map((preset) {
              final isSelected = selected.hour == preset.hour &&
                  selected.minute == preset.minute;
              return _quickChip(
                label: preset.label,
                selected: isSelected,
                onTap: () => controller.selectStartTimePreset(
                  preset.hour,
                  preset.minute,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _pickTime(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isValid
                      ? AppColor.primary.withValues(alpha: 0.4)
                      : AppColor.alertRed.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: isValid ? AppColor.primary : AppColor.alertRed,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start time',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: AppColor.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.startTimeLabel,
                          style: AppTextStyle.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Change',
                    style: AppTextStyle.labelMedium.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColor.primary, size: 20),
                ],
              ),
            ),
          ),
          if (!isValid) ...[
            const SizedBox(height: 8),
            Text(
              'This time has already passed. Pick a later time.',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.alertRed,
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _startLocationCard({required BuildContext context}) {
    final loc = Get.find<LocationService>();

    return Obx(() {
      final useCurrent = controller.useCurrentLocationAsStart.value;
      final label = controller.startLocationLabel.value;
      final hasPermission = loc.permissionGranted.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationOptionTile(
            icon: Icons.my_location_rounded,
            title: 'Current location',
            subtitle: useCurrent && label.isNotEmpty
                ? label
                : (useCurrent ? 'Fetching location…' : null),
            selected: useCurrent,
            onTap: () => controller.setUseCurrentLocationAsStart(true),
          ),
          if (useCurrent) ...[
            const SizedBox(height: 8),
            if (!hasPermission)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location permission is needed to plan from where you are.',
                      style: AppTextStyle.bodyMedium,
                    ),
                    TextButton(
                      onPressed: controller.enableLocationForTrip,
                      child: Text(
                        'Enable location',
                        style: AppTextStyle.labelMedium.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: controller.refreshStartLocation,
                  icon: const Icon(Icons.refresh_rounded,
                      size: 18, color: AppColor.primary),
                  label: Text(
                    'Refresh',
                    style: AppTextStyle.labelMedium.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 10),
          _locationOptionTile(
            icon: Icons.edit_location_alt_rounded,
            title: 'Select manually',
            subtitle: !useCurrent && label.isNotEmpty ? label : null,
            selected: !useCurrent,
            onTap: () => controller.setUseCurrentLocationAsStart(false),
          ),
          if (!useCurrent) ...[
            const SizedBox(height: 16),
            _startDistrictDropdown(),
            const SizedBox(height: 12),
            _startSubDistrictDropdown(),
          ],
        ],
      );
    });
  }

  Widget _locationOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColor.primary : AppColor.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected ? AppColor.primary : AppColor.textSecondary,
                size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColor.primary : AppColor.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _startDistrictDropdown() {
    return Obx(() {
      final districts = controller.districts;
      final selected = controller.selectedStartDistrict.value;

      return _locationDropdownField<DistrictModel>(
        label: 'District',
        hint: 'Select district',
        value: selected,
        items: districts,
        itemLabel: (d) => d.name,
        onChanged: controller.selectStartDistrict,
      );
    });
  }

  Widget _startSubDistrictDropdown() {
    return Obx(() {
      final subDistricts = controller.startSubDistricts;
      final selected = controller.selectedStartSubDistrict.value;
      final hasDistrict = controller.selectedStartDistrict.value != null;

      return _locationDropdownField<SubDistrictModel>(
        label: 'Sub-district',
        hint: hasDistrict ? 'Select sub-district' : 'Select district first',
        value: selected,
        items: subDistricts,
        itemLabel: (s) => s.name,
        onChanged: hasDistrict ? controller.selectStartSubDistrict : null,
      );
    });
  }

  Widget _locationDropdownField<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    ValueChanged<T?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelSmall.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColor.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                style: AppTextStyle.bodyMedium,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColor.primary),
              dropdownColor: AppColor.bgCard,
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        itemLabel(item),
                        style: AppTextStyle.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
