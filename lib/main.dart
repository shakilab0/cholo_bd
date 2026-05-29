import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/services/gemini_transport_filter_service.dart';
import 'package:cholo_bd/core/services/google_routes_service.dart';
import 'package:cholo_bd/core/services/location_service.dart';
import 'package:cholo_bd/core/services/notification_service.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Hive init
  await Hive.initFlutter();
  await openHiveBoxes();
  log('Hive initialized.');

  // Notifications init
  await NotificationService.instance.init();

  Get.put(LocationService(), permanent: true);
  Get.put(GeminiTransportFilterService(), permanent: true);
  Get.put(GoogleRoutesService(), permanent: true);

  runApp(const MyApp());
}
