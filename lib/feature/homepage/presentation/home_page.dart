import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/district_card.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/featured_slider.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/home_search_bar.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/quick_actions_row.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/season_banner.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: HomeSearchBar(controller: controller)),
          ],
          body: RefreshIndicator(
            color: AppColor.primary,
            backgroundColor: AppColor.bgCard,
            onRefresh: () async {
              // Pull to refresh: reload data
            },
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Season Banner
                SeasonBanner(controller: controller),

                // Featured Places Slider
                _SectionHeader(
                  title: AppStrings.featuredPlaces,
                  onSeeAll: () {},
                ),
                Obx(() => controller.isLoadingFeatured.value
                    ? _shimmerSlider()
                    : controller.featuredPlaces.isEmpty
                        ? const SizedBox.shrink()
                        : FeaturedSlider(
                            places: controller.featuredPlaces,
                            onTap: controller.navigateToPlaceDetails,
                          )),

                const SizedBox(height: 16),

                // Quick Actions
                _SectionHeader(
                  title: 'Quick Actions',
                  showSeeAll: false,
                ),
                QuickActionsRow(controller: controller),

                const SizedBox(height: 16),

                // Explore Districts
                _SectionHeader(
                  title: AppStrings.exploreDistricts,
                  onSeeAll: () {},
                ),
                Obx(() {
                  if (controller.isLoadingDistricts.value) {
                    return _shimmerGrid();
                  }
                  final list = controller.filteredDistricts;
                  if (list.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text('No districts found',
                            style: AppTextStyle.bodyMedium),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => DistrictCard(
                      district: list[i],
                      onTap: () =>
                          controller.navigateToDistrictPlaces(list[i]),
                    ),
                  );
                }),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Location pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded,
                    color: AppColor.primary, size: 16),
                const SizedBox(width: 4),
                Text('Bangladesh', style: AppTextStyle.labelSmall),
              ],
            ),
          ),
          const Spacer(),
          // Language toggle
          Obx(() => GestureDetector(
                onTap: controller.toggleLanguage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColor.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    MyApp.isEnglish.value ? 'EN' : 'বাং',
                    style: AppTextStyle.labelSmall
                        .copyWith(color: AppColor.primary),
                  ),
                ),
              )),
          const SizedBox(width: 8),
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColor.bgCard,
            child: const Icon(Icons.person_rounded,
                color: AppColor.textSecondary, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _shimmerSlider() {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _shimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColor.shimmerBase,
          highlightColor: AppColor.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.shimmerBase,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool showSeeAll;

  const _SectionHeader({
    required this.title,
    this.onSeeAll,
    this.showSeeAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.sectionTitle),
          if (showSeeAll && onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(AppStrings.seeAll,
                  style: AppTextStyle.labelSmall
                      .copyWith(color: AppColor.primary)),
            ),
        ],
      ),
    );
  }
}
