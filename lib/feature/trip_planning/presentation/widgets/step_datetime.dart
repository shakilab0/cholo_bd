import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/core/services/location_service.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/sub_district_model.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class StepDatetime extends StatelessWidget {
  final TripPlanningController controller;
  const StepDatetime({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final en = MyApp.isEnglish.value;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            en ? 'When are you going?' : 'কখন যাবেন?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColor.textPrimary,
            ),
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
                _QuickChip(
                  label: en ? 'Today' : 'আজ',
                  selected: quickLabel == 'today',
                  onTap: () => controller.selectDateQuick(0),
                ),
                _QuickChip(
                  label: en ? 'Tomorrow' : 'আগামীকাল',
                  selected: quickLabel == 'tomorrow',
                  onTap: () => controller.selectDateQuick(1),
                ),
                _QuickChip(
                  label: en ? 'This Weekend' : 'এই সপ্তাহান্ত',
                  selected: quickLabel == 'weekend',
                  onTap: controller.selectThisWeekend,
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          _DatePickerField(controller: controller),
          const SizedBox(height: 24),
          Text(
            en ? 'What time will you start?' : 'কখন শুরু করবেন?',
            style: AppTextStyle.heading3,
          ),
          const SizedBox(height: 6),
          Text(
            en
                ? 'Bus or train departure, pickup time, etc.'
                : 'বাস/ট্রেনের সময়, রিকশা পিকআপের সময় ইত্যাদি',
            style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
          ),
          const SizedBox(height: 12),
          _StartTimeSection(controller: controller),
          const SizedBox(height: 24),
          Text(
            en ? 'Where will you start?' : 'কোথা থেকে শুরু করবেন?',
            style: AppTextStyle.heading3,
          ),
          const SizedBox(height: 12),
          _StartLocationCard(controller: controller),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final TripPlanningController controller;
  const _DatePickerField({required this.controller});

  Future<void> _openCalendar(BuildContext context) async {
    final en = MyApp.isEnglish.value;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var picked = controller.selectedDate.value;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColor.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  en ? 'Pick a date' : 'তারিখ বেছে নিন',
                  style: AppTextStyle.sectionTitle,
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
                        en ? 'Cancel' : 'বাতিল',
                        style: AppTextStyle.labelSmall
                            .copyWith(color: AppColor.textSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.selectDate(picked);
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        en ? 'Done' : 'নির্বাচন',
                        style: AppTextStyle.labelSmall
                            .copyWith(color: AppColor.primary),
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

  @override
  Widget build(BuildContext context) {
    final en = MyApp.isEnglish.value;

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
                      en ? 'Selected date' : 'নির্বাচিত তারিখ',
                      style: AppTextStyle.labelSmall
                          .copyWith(color: AppColor.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy').format(selected),
                      style: AppTextStyle.sectionTitle,
                    ),
                  ],
                ),
              ),
              Text(
                en ? 'Change' : 'পরিবর্তন',
                style:
                    AppTextStyle.labelSmall.copyWith(color: AppColor.primary),
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
}

class _StartTimeSection extends StatelessWidget {
  final TripPlanningController controller;
  const _StartTimeSection({required this.controller});

  static const _presets = [
    (hour: 6, minute: 0, en: '6 AM', bn: '৬টা'),
    (hour: 8, minute: 0, en: '8 AM', bn: '৮টা'),
    (hour: 12, minute: 0, en: '12 PM', bn: '১২টা'),
    (hour: 15, minute: 0, en: '3 PM', bn: '৩টা'),
    (hour: 18, minute: 0, en: '6 PM', bn: '৬টা'),
    (hour: 20, minute: 0, en: '8 PM', bn: '৮টা'),
  ];

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

  @override
  Widget build(BuildContext context) {
    final en = MyApp.isEnglish.value;

    return Obx(() {
      final selected = controller.selectedStartTime.value;
      final isValid = controller.isStartTimeValid;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presets.map((preset) {
              final isSelected =
                  selected.hour == preset.hour && selected.minute == preset.minute;
              return _QuickChip(
                label: en ? preset.en : preset.bn,
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
                          en ? 'Start time' : 'শুরুর সময়',
                          style: AppTextStyle.labelSmall
                              .copyWith(color: AppColor.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.startTimeLabel,
                          style: AppTextStyle.sectionTitle,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    en ? 'Change' : 'পরিবর্তন',
                    style: AppTextStyle.labelSmall
                        .copyWith(color: AppColor.primary),
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
              en
                  ? 'This time has already passed. Pick a later time.'
                  : 'এই সময় ইতিমধ্যে পেরিয়ে গেছে। পরের সময় বেছে নিন।',
              style: AppTextStyle.labelSmall.copyWith(color: AppColor.alertRed),
            ),
          ],
        ],
      );
    });
  }
}

class _StartLocationCard extends StatelessWidget {
  final TripPlanningController controller;
  const _StartLocationCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final en = MyApp.isEnglish.value;
    final loc = Get.find<LocationService>();

    return Obx(() {
      final useCurrent = controller.useCurrentLocationAsStart.value;
      final label = controller.startLocationLabel.value;
      final hasPermission = loc.permissionGranted.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LocationOptionTile(
            icon: Icons.my_location_rounded,
            title: en ? 'Current location' : 'বর্তমান লোকেশন',
            subtitle: useCurrent && label.isNotEmpty
                ? label
                : (useCurrent
                    ? (en ? 'Fetching location…' : 'লোকেশন লোড হচ্ছে…')
                    : null),
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
                      en
                          ? 'Location permission is needed to plan from where you are.'
                          : 'আপনার অবস্থান থেকে ট্রিপ প্ল্যান করতে লোকেশন অনুমতি দিন।',
                      style: AppTextStyle.labelSmall
                          .copyWith(color: AppColor.textSecondary),
                    ),
                    TextButton(
                      onPressed: controller.enableLocationForTrip,
                      child: Text(
                        en ? 'Enable location' : 'লোকেশন চালু করুন',
                        style: AppTextStyle.labelSmall
                            .copyWith(color: AppColor.primary),
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
                    en ? 'Refresh' : 'রিফ্রেশ',
                    style: AppTextStyle.labelSmall
                        .copyWith(color: AppColor.primary),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 10),
          _LocationOptionTile(
            icon: Icons.edit_location_alt_rounded,
            title: en ? 'Select manually' : 'নিজে বেছে নিন',
            subtitle: !useCurrent && label.isNotEmpty ? label : null,
            selected: !useCurrent,
            onTap: () => controller.setUseCurrentLocationAsStart(false),
          ),
          if (!useCurrent) ...[
            const SizedBox(height: 16),
            _StartDistrictDropdown(controller: controller),
            const SizedBox(height: 12),
            _StartSubDistrictDropdown(controller: controller),
          ],
        ],
      );
    });
  }
}

class _LocationOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LocationOptionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text(title, style: AppTextStyle.sectionTitle),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyle.labelSmall.copyWith(
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
}

class _StartDistrictDropdown extends StatelessWidget {
  final TripPlanningController controller;
  const _StartDistrictDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    final en = MyApp.isEnglish.value;

    return Obx(() {
      final districts = controller.districts;
      final selected = controller.selectedStartDistrict.value;

      return _LocationDropdownField<DistrictModel>(
        label: en ? 'District' : 'জেলা',
        hint: en ? 'Select district' : 'জেলা বেছে নিন',
        value: selected,
        items: districts,
        itemLabel: (d) => en ? d.name : d.nameBn,
        onChanged: controller.selectStartDistrict,
      );
    });
  }
}

class _StartSubDistrictDropdown extends StatelessWidget {
  final TripPlanningController controller;
  const _StartSubDistrictDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    final en = MyApp.isEnglish.value;

    return Obx(() {
      final subDistricts = controller.startSubDistricts;
      final selected = controller.selectedStartSubDistrict.value;
      final hasDistrict = controller.selectedStartDistrict.value != null;

      return _LocationDropdownField<SubDistrictModel>(
        label: en ? 'Sub-district' : 'উপজেলা',
        hint: hasDistrict
            ? (en ? 'Select sub-district' : 'উপজেলা বেছে নিন')
            : (en ? 'Select district first' : 'আগে জেলা বেছে নিন'),
        value: selected,
        items: subDistricts,
        itemLabel: (s) => en ? s.name : s.nameBn,
        onChanged: hasDistrict ? controller.selectStartSubDistrict : null,
      );
    });
  }
}

class _LocationDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;

  const _LocationDropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelSmall.copyWith(color: AppColor.textSecondary),
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
                style: AppTextStyle.bodySmall
                    .copyWith(color: AppColor.textSecondary),
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
                        style: AppTextStyle.bodySmall,
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

class _QuickChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          style: AppTextStyle.labelSmall.copyWith(
            color: selected ? AppColor.inkDark : AppColor.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
