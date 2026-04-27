import 'package:get/get.dart';
import 'package:cholo_bd/feature/splash_screen/splash_screen.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_page.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_binding.dart';
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

final List<GetPage> appRoutes = [
  GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
  GetPage(
    name: AppRoutes.onboarding,
    page: () => const OnboardingPage(),
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
];

class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
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
}
