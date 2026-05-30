import 'package:get/get.dart';
import 'package:cholo_bd/feature/splash_screen/splash_screen.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_binding.dart';
import 'package:cholo_bd/feature/onboarding/pages/onboarding_step1_page.dart';
import 'package:cholo_bd/feature/onboarding/pages/onboarding_step2_page.dart';
import 'package:cholo_bd/feature/onboarding/pages/onboarding_step3_page.dart';
import 'package:cholo_bd/feature/onboarding/pages/onboarding_step4_name_page.dart';
import 'package:cholo_bd/feature/onboarding/pages/onboarding_step5_preference_page.dart';
import 'package:cholo_bd/feature/auth/auth_page.dart';
import 'package:cholo_bd/feature/auth/auth_binding.dart';
import 'package:cholo_bd/feature/tabbar/tabbar_view_page.dart';
import 'package:cholo_bd/feature/tabbar/tabbar_binding.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_binding.dart';
import 'package:cholo_bd/feature/district_places/district_places_page.dart';
import 'package:cholo_bd/feature/district_places/district_places_binding.dart';
import 'package:cholo_bd/feature/place_details/place_details_page.dart';
import 'package:cholo_bd/feature/place_details/place_details_binding.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_page.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_binding.dart';
import 'package:cholo_bd/feature/trips/trips_page.dart';
import 'package:cholo_bd/feature/trips/trips_binding.dart';
import 'package:cholo_bd/feature/trip_details/trip_details_page.dart';
import 'package:cholo_bd/feature/trip_details/trip_details_binding.dart';
import 'package:cholo_bd/feature/profile/profile_page.dart';
import 'package:cholo_bd/feature/profile/profile_binding.dart';
import 'package:cholo_bd/feature/map/map_page.dart';
import 'package:cholo_bd/feature/map/map_binding.dart';
import 'package:cholo_bd/feature/active_trip/active_trip_page.dart';
import 'package:cholo_bd/feature/active_trip/active_trip_binding.dart';
import 'package:cholo_bd/feature/all_districts/all_districts_page.dart';
import 'package:cholo_bd/feature/category_places/category_places_page.dart';
import 'package:cholo_bd/feature/category_places/category_places_binding.dart';

final List<GetPage> appRoutes = [
  GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
  GetPage(
    name: AppRoutes.onboardingStep1,
    page: () => const OnboardingStep1Page(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: AppRoutes.onboardingStep2,
    page: () => const OnboardingStep2Page(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: AppRoutes.onboardingStep3,
    page: () => const OnboardingStep3Page(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: AppRoutes.onboardingName,
    page: () => const OnboardingStep4NamePage(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: AppRoutes.onboardingPreference,
    page: () => const OnboardingStep5PreferencePage(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: AppRoutes.auth,
    page: () => const AuthPage(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoutes.tabbar,
    page: () => const TabbarViewPage(),
    binding: TabbarBinding(),
  ),
  GetPage(
    name: AppRoutes.home,
    page: () => const HomePage(),
    binding: HomePageBinding(),
  ),
  GetPage(
    name: AppRoutes.districtPlaces,
    page: () => const DistrictPlacesPage(),
    binding: DistrictPlacesBinding(),
  ),
  GetPage(
    name: AppRoutes.placeDetails,
    page: () => const PlaceDetailsPage(),
    binding: PlaceDetailsBinding(),
  ),
  GetPage(
    name: AppRoutes.tripPlanning,
    page: () => const TripPlanningPage(),
    binding: TripPlanningBinding(),
  ),
  GetPage(
    name: AppRoutes.trips,
    page: () => const TripsPage(),
    binding: TripsBinding(),
  ),
  GetPage(
    name: AppRoutes.tripDetails,
    page: () => const TripDetailsPage(),
    binding: TripDetailsBinding(),
  ),
  GetPage(
    name: AppRoutes.profile,
    page: () => const ProfilePage(),
    binding: ProfileBinding(),
  ),
  GetPage(
    name: AppRoutes.map,
    page: () => const MapPage(),
    binding: MapBinding(),
  ),
  GetPage(
    name: AppRoutes.activeTrip,
    page: () => const ActiveTripPage(),
    binding: ActiveTripBinding(),
  ),
  GetPage(
    name: AppRoutes.allDistricts,
    page: () => const AllDistrictsPage(),
  ),
  GetPage(
    name: AppRoutes.categoryPlaces,
    page: () => const CategoryPlacesPage(),
    binding: CategoryPlacesBinding(),
  ),
];

class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String onboardingStep1 = '/onboarding/1';
  static const String onboardingStep2 = '/onboarding/2';
  static const String onboardingStep3 = '/onboarding/3';
  static const String onboardingName = '/onboarding/name';
  static const String onboardingPreference = '/onboarding/preference';
  static const String auth = '/auth';
  static const String tabbar = '/tabbar';
  static const String home = '/home';
  static const String districtPlaces = '/district-places';
  static const String placeDetails = '/place-details';
  static const String tripPlanning = '/trip-planning';
  static const String trips = '/trips';
  static const String tripDetails = '/trip-details';
  static const String profile = '/profile';
  static const String map = '/map';
  static const String activeTrip = '/active-trip';
  static const String allDistricts = '/all-districts';
  static const String categoryPlaces = '/category-places';
}
