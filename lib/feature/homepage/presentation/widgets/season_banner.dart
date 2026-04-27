import 'package:flutter/material.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';

class SeasonBanner extends StatelessWidget {
  final HomePageController controller;
  const SeasonBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004D40), Color(0xFF00695C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(controller.seasonIcon, color: AppColor.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.seasonBannerText,
              style: AppTextStyle.labelSmall
                  .copyWith(color: AppColor.textPrimary),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
