import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/feature/tabbar/tabbar_controller.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page.dart';
import 'package:cholo_bd/feature/map/map_page.dart';
import 'package:cholo_bd/feature/trips/trips_page.dart';
import 'package:cholo_bd/feature/profile/profile_page.dart';

class TabbarViewPage extends GetView<TabbarController> {
  const TabbarViewPage({super.key});

  static final List<Widget> _pages = [
    const HomePage(),
    const TripsPage(),
    const MapPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColor.bgCard,
            selectedItemColor: AppColor.primary,
            unselectedItemColor: AppColor.textSecondary,
            selectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.luggage_rounded), label: 'My Trips'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_rounded), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ));
  }
}
