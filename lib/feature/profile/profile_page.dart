import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/profile/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileHeader(controller: c),
                    const SizedBox(height: 24),
                    _StatsRow(controller: c),
                    const SizedBox(height: 24),
                    _LanguageToggle(controller: c),
                    const SizedBox(height: 16),
                    _SettingsSection(),
                    const SizedBox(height: 24),
                    _GuestBanner(controller: c),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColor.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.primary, width: 2),
          ),
          child: const Icon(Icons.person_rounded,
              color: AppColor.primary, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.displayName, style: AppTextStyle.heading3),
              const SizedBox(height: 2),
              Obx(() => Text(
                    controller.isGuest
                        ? 'Guest Explorer'
                        : 'Smart Traveler',
                    style: AppTextStyle.bodySmall,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ProfileController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
          ),
          child: Row(
            children: [
              _StatItem(
                value: controller.totalTrips.value.toString(),
                label: 'Trips',
                icon: Icons.luggage_rounded,
              ),
              _StatDivider(),
              _StatItem(
                value: controller.placesVisited.value.toString(),
                label: 'Places',
                icon: Icons.place_rounded,
              ),
              _StatDivider(),
              _StatItem(
                value: controller.districtsExplored.value.toString(),
                label: 'Districts',
                icon: Icons.map_rounded,
              ),
            ],
          ),
        ));
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatItem(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColor.primary, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: AppTextStyle.heading3.copyWith(color: AppColor.primary)),
          Text(label, style: AppTextStyle.caption),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 48, color: AppColor.border);
  }
}

class _LanguageToggle extends StatelessWidget {
  final ProfileController controller;
  const _LanguageToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.translate_rounded,
              color: AppColor.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language', style: AppTextStyle.labelSmall.copyWith(
                    color: AppColor.textPrimary, fontWeight: FontWeight.w600)),
                Obx(() => Text(
                      MyApp.isEnglish.value ? 'English' : 'বাংলা',
                      style: AppTextStyle.caption,
                    )),
              ],
            ),
          ),
          Obx(() => GestureDetector(
                onTap: controller.toggleLanguage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 28,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: MyApp.isEnglish.value
                        ? AppColor.primary
                        : AppColor.bgCardLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: MyApp.isEnglish.value
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              MyApp.isEnglish.value ? 'EN' : 'বাং',
                              style: const TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.inkDark),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.notifications_rounded,
            label: 'Notifications',
            onTap: () {},
          ),
          const Divider(color: AppColor.border, height: 1, indent: 52),
          _SettingsTile(
            icon: Icons.cloud_download_rounded,
            label: 'Offline Data',
            onTap: () {},
          ),
          const Divider(color: AppColor.border, height: 1, indent: 52),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: 'About Smart Travel BD',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColor.primary, size: 20),
      title: Text(label, style: AppTextStyle.labelSmall.copyWith(
          color: AppColor.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColor.textSecondary, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
    );
  }
}

class _GuestBanner extends StatelessWidget {
  final ProfileController controller;
  const _GuestBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isGuest) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primary.withValues(alpha: 0.15),
              AppColor.accent.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud_sync_rounded,
                    color: AppColor.primary, size: 20),
                const SizedBox(width: 10),
                Text('Sync your trips to the cloud',
                    style: AppTextStyle.sectionTitle),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Sign in to save your trips online and access them from any device.',
              style: AppTextStyle.bodySmall,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.auth),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.inkDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Sign In / Sign Up',
                    style: AppTextStyle.labelSmall.copyWith(
                        color: AppColor.inkDark,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
    });
  }
}
