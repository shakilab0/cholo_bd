import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';
import 'package:cholo_bd/feature/homepage/presentation/widgets/district_card.dart';

class AllDistrictsPage extends StatefulWidget {
  const AllDistrictsPage({super.key});

  @override
  State<AllDistrictsPage> createState() => _AllDistrictsPageState();
}

class _AllDistrictsPageState extends State<AllDistrictsPage> {
  late HomePageController _homeCtrl;
  final TextEditingController _searchCtrl = TextEditingController();
  final RxString _query = ''.obs;

  @override
  void initState() {
    super.initState();
    _homeCtrl = Get.find<HomePageController>();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DistrictModel> get _filtered {
    final q = _query.value.trim().toLowerCase();
    if (q.isEmpty) return _homeCtrl.districts;
    return _homeCtrl.districts.where((d) {
      return d.name.toLowerCase().contains(q) ||
          d.nameBn.contains(_query.value.trim());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      appBar: AppBar(
        backgroundColor: AppColor.bgDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColor.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text('Bangladesh', style: AppTextStyle.heading3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => _query.value = v,
              style: AppTextStyle.bodyMedium
                  .copyWith(color: AppColor.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search districts...',
                hintStyle: AppTextStyle.bodyMedium,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColor.textSecondary, size: 20),
                suffixIcon: Obx(() => _query.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppColor.textSecondary, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          _query.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
                filled: true,
                fillColor: AppColor.bgCard,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Grid
          Expanded(
            child: Obx(() {
              if (_homeCtrl.isLoadingDistricts.value) {
                return _shimmerGrid();
              }
              final list = _filtered;
              if (list.isEmpty) {
                return Center(
                  child: Text('No districts found',
                      style: AppTextStyle.bodyMedium),
                );
              }
              return GridView.builder(
                padding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                      _homeCtrl.navigateToDistrictPlaces(list[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: 12,
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
    );
  }
}
