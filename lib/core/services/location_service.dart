import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';

class LocationService extends GetxService {
  final Rx<LatLng?> position = Rx<LatLng?>(null);
  final RxString areaLabel = 'Bangladesh'.obs;
  final RxBool isLoading = false.obs;
  final RxBool permissionGranted = false.obs;

  static const _defaultLabel = 'Bangladesh';

  bool get hasValidPosition => position.value != null;

  String get displayLabel {
    if (isLoading.value) return _defaultLabel;
    if (!permissionGranted.value) return _defaultLabel;
    return areaLabel.value.isNotEmpty ? areaLabel.value : _defaultLabel;
  }

  @override
  void onInit() {
    super.onInit();
    _restoreFromCache();
  }

  void _restoreFromCache() {
    final cached = getCachedLocation();
    if (cached == null) return;
    final lat = cached['lat'] as double?;
    final lng = cached['lng'] as double?;
    final label = cached['label'] as String?;
    if (lat != null && lng != null) {
      position.value = LatLng(lat, lng);
      if (label != null && label.isNotEmpty) {
        areaLabel.value = label;
        permissionGranted.value = true;
      }
    }
  }

  Future<void> requestAndRefresh() async {
    isLoading.value = true;
    try {
      final allowed = await _ensurePermission();
      permissionGranted.value = allowed;
      if (!allowed) {
        areaLabel.value = _defaultLabel;
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      position.value = latLng;

      if (!_isInBangladesh(latLng)) {
        areaLabel.value = _defaultLabel;
        log('Location outside Bangladesh bounds');
        return;
      }

      final label = await _reverseGeocode(latLng);
      areaLabel.value = label;
      await saveCachedLocation(
        lat: latLng.latitude,
        lng: latLng.longitude,
        label: label,
      );
    } catch (e) {
      log('LocationService requestAndRefresh: $e');
      if (position.value == null) {
        areaLabel.value = _defaultLabel;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _ensurePermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      return false;
    }
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;
    return true;
  }

  Future<String> _reverseGeocode(LatLng latLng) async {
    try {
      final places = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (places.isEmpty) return _defaultLabel;
      final p = places.first;
      final parts = <String>[
        if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
        if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
        if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
          p.administrativeArea!,
      ];
      if (parts.isEmpty) return _defaultLabel;
      return parts.take(2).join(', ');
    } catch (e) {
      log('reverseGeocode error: $e');
      return _defaultLabel;
    }
  }

  bool _isInBangladesh(LatLng p) {
    return p.latitude >= 20.0 &&
        p.latitude <= 27.5 &&
        p.longitude >= 88.0 &&
        p.longitude <= 93.5;
  }

  Future<void> openSettings() => Geolocator.openAppSettings();
}
