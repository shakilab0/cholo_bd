import 'package:flutter/material.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';

class HomeSearchBar extends StatelessWidget {
  final HomePageController controller;
  const HomeSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        onSubmitted: controller.onSearchSubmit,
        style: AppTextStyle.bodyLarge,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: AppTextStyle.bodyMedium,
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColor.textSecondary),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.searchController,
            builder: (_, value, __) => value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColor.textSecondary),
                    onPressed: controller.clearSearch,
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: AppColor.bgCard,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            borderSide: const BorderSide(color: AppColor.primary),
          ),
        ),
      ),
    );
  }
}
