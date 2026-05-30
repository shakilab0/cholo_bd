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
                    profileHeader(controller: c, context: context),
                    const SizedBox(height: 24),
                    statsRow(controller: c, context: context),
                    const SizedBox(height: 24, ),
                    languageToggle(controller: c,context: context),
                    const SizedBox(height: 16),
                    notificationTestButton(controller: c),
                    const SizedBox(height: 16),
                    settingsSection(context: context),
                    const SizedBox(height: 24),
                    guestBanner(controller: c,context: context),
                    const SizedBox(height: 16),
                    logoutButton(controller: c,context: context),
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


  Widget profileHeader({required BuildContext context,required ProfileController controller}){
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
              Obx(() => Text(controller.displayName.value,
                  style: AppTextStyle.heading3)),
              const SizedBox(height: 2),
              Text(controller.displaySubtitle, style: AppTextStyle.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget statsRow({required BuildContext context,required ProfileController controller}){
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          statItem(
            value: controller.totalTrips.value.toString(),
            label: 'Trips',
            icon: Icons.luggage_rounded,
            context: context,
          ),
          Container(width: 1, height: 48, color: AppColor.border),
          statItem(
            value: controller.placesVisited.value.toString(),
            label: 'Places',
            icon: Icons.place_rounded,
            context: context,
          ),
          Container(width: 1, height: 48, color: AppColor.border),
          statItem(
            value: controller.districtsExplored.value.toString(),
            label: 'Districts',
            icon: Icons.map_rounded,
            context: context,
          ),
        ],
      ),
    ));
  }

  Widget statItem({required BuildContext context,required  String value, required String label, required IconData icon,}){
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

  Widget languageToggle({required BuildContext context,required ProfileController controller}){
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

  Widget notificationTestButton({required ProfileController controller}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.testNotification,
        icon: const Icon(Icons.notifications_active_rounded,
            color: AppColor.primary, size: 20),
        label: Text(
          'Test Notification',
          style: AppTextStyle.labelSmall.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColor.primary.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColor.bgCard,
        ),
      ),
    );
  }

  Widget settingsSection({required BuildContext context}){
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          settingsTile(
            icon: Icons.cloud_download_rounded,
            label: 'Offline Data',
            onTap: () {},
            context: context,
          ),
          const Divider(color: AppColor.border, height: 1, indent: 52),
          settingsTile(
            icon: Icons.info_outline_rounded,
            label: 'About Smart Travel BD',
            onTap: () {},
            context: context,
          ),
        ],
      ),
    );
  }

  Widget settingsTile({required BuildContext context,required IconData icon, required String label,required VoidCallback onTap}){
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

  Widget logoutButton({required BuildContext context,required ProfileController controller}){
    return Obx(() {
      if (controller.isGuest) return const SizedBox.shrink();
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => Get.dialog(
            AlertDialog(
              backgroundColor: AppColor.bgCard,
              title: Text('Sign Out', style: AppTextStyle.sectionTitle),
              content: Text(
                'Are you sure you want to sign out?',
                style: AppTextStyle.bodySmall,
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel',
                      style: AppTextStyle.labelSmall
                          .copyWith(color: AppColor.textSecondary)),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.logout();
                  },
                  child: Text('Sign Out',
                      style: AppTextStyle.labelSmall
                          .copyWith(color: AppColor.alertRed)),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.logout_rounded,
              color: AppColor.alertRed, size: 18),
          label: Text('Sign Out',
              style: AppTextStyle.labelSmall
                  .copyWith(color: AppColor.alertRed, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColor.alertRed),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
    });
  }

  Widget guestBanner({required BuildContext context,required ProfileController controller}){
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
