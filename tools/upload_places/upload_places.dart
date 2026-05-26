import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

import 'districts_data.dart';
import 'place_generator.dart';

const _endpoint = 'https://sgp.cloud.appwrite.io/v1';
const _projectId = '69ec2d6c00274656ee64';
const _databaseId = '69ec314b0038beeb4258';
const _placesCollection = 'places';
const _districtsCollection = 'districts';

bool _isBenignParseError(Object e) {
  final s = e.toString();
  return s.contains('List<dynamic>') && s.contains('List<String>');
}

bool _isAlreadyExists(Object e) {
  final s = e.toString().toLowerCase();
  return s.contains('already exists') ||
      s.contains('document_already_exists') ||
      s.contains('409');
}

Map<String, dynamic> _placePayload(
  Map<String, dynamic> place,
  String districtId,
  String districtName,
) {
  return {
    'name': place['name'],
    'name_bn': place['name_bn'],
    'description': place['description'],
    'district_id': districtId,
    'district_name': districtName,
    'images': place['images'] ?? <String>[],
    'videos': place['videos'] ?? <String>[],
    'entry_fee': place['entry_fee'] ?? 0.0,
    'is_free_entry': place['is_free_entry'] ?? true,
    'visit_duration': place['visit_duration'] ?? '2-3 hours',
    'best_time': place['best_time'] ?? 'October - March',
    'opening_hours': place['opening_hours'] ?? 'Open daily',
    'latitude': place['latitude'],
    'longitude': place['longitude'],
    'rating': place['rating'] ?? 4.0,
    'review_count': place['review_count'] ?? 100,
    'tags': place['tags'] ?? <String>['local'],
  };
}

Future<void> main(List<String> args) async {
  final apiKey = Platform.environment['APPWRITE_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln(
      '❌ Set APPWRITE_API_KEY environment variable.\n'
      '   Example: export APPWRITE_API_KEY=\'your_key\'',
    );
    exit(1);
  }

  final client = Client()
      .setEndpoint(_endpoint)
      .setProject(_projectId)
      .setKey(apiKey);
  final databases = Databases(client);

  if (args.contains('--update-counts')) {
    await _updateDistrictPlaceCounts(databases);
    return;
  }

  if (args.contains('--add-videos-field')) {
    await _addVideosAttribute(databases);
    if (args.contains('--sync-media')) {
      await _waitForVideosAttribute(databases);
      await _syncPlaceMedia(databases);
    }
    return;
  }

  if (args.contains('--sync-media')) {
    await _syncPlaceMedia(databases);
    return;
  }

  await _uploadPlaces(databases);
}

/// Creates `videos` (string array) on the `places` collection in Appwrite.
Future<void> _addVideosAttribute(Databases databases) async {
  print('Creating `videos` attribute on places collection...\n');
  try {
    await databases.createStringAttribute(
      databaseId: _databaseId,
      collectionId: _placesCollection,
      key: 'videos',
      size: 2048,
      xrequired: false,
      array: true,
    );
    print('✅ Attribute `videos` created (processing — may take a minute).');
  } catch (e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('already exists') || msg.contains('attribute_already_exists')) {
      print('⏭️  Attribute `videos` already exists.');
    } else if (_isBenignParseError(e)) {
      print('✅ Attribute `videos` created.');
    } else {
      print('❌ Failed: $e');
      exit(1);
    }
  }
  print('\nNext: dart run upload_places.dart --sync-media');
}

Future<void> _waitForVideosAttribute(Databases databases) async {
  print('\nWaiting for `videos` attribute to become available...');
  for (var i = 0; i < 30; i++) {
    await Future<void>.delayed(const Duration(seconds: 2));
    try {
      final list = await databases.listAttributes(
        databaseId: _databaseId,
        collectionId: _placesCollection,
      );
      String? status;
      for (final a in list.attributes) {
        final key = a is Map ? a['key'] : (a as dynamic).key;
        if (key == 'videos') {
          status = a is Map ? a['status'] as String? : (a as dynamic).status as String?;
          break;
        }
      }
      if (status == null) continue;
      if (status == 'available') {
        print('✅ `videos` is available.\n');
        return;
      }
      print('   … status: $status');
    } catch (_) {
      // keep polling
    }
  }
  print('⚠️  Timed out waiting; try --sync-media again in a minute.');
}

Future<void> _uploadPlaces(Databases databases) async {
  var success = 0;
  var skipped = 0;
  var failed = 0;

  print('Uploading 4 places × ${districts.length} districts...\n');

  for (final district in districts) {
    final districtId = district['id'] as String;
    final districtName = district['name'] as String;
    final places = placesForDistrict(district);

    for (var i = 0; i < places.length; i++) {
      final place = places[i];
      final docId = '$districtId-place-${i + 1}';
      final data = _placePayload(place, districtId, districtName);

      try {
        await databases.createDocument(
          databaseId: _databaseId,
          collectionId: _placesCollection,
          documentId: docId,
          data: data,
        );
        print('✅ $docId');
        success++;
      } catch (e) {
        if (_isAlreadyExists(e)) {
          print('⏭️  $docId (exists)');
          skipped++;
        } else if (_isBenignParseError(e)) {
          print('✅ $docId');
          success++;
        } else {
          print('❌ $docId — $e');
          failed++;
        }
      }
    }
  }

  print('\n─────────────────────────────');
  print('Done. ✅ $success uploaded   ⏭️  $skipped skipped   ❌ $failed failed');
  print('\nOptional:');
  print('  dart run upload_places.dart --sync-media');
  print('  dart run upload_places.dart --update-counts');
}

/// Updates images + videos on existing place documents (after adding `videos` attribute).
Future<void> _syncPlaceMedia(Databases databases) async {
  print('Syncing images & videos on existing places...\n');
  var ok = 0;
  var fail = 0;

  for (final district in districts) {
    final districtId = district['id'] as String;
    final districtName = district['name'] as String;
    final places = placesForDistrict(district);

    for (var i = 0; i < places.length; i++) {
      final docId = '$districtId-place-${i + 1}';
      final data = {
        'images': places[i]['images'] ?? <String>[],
        'videos': places[i]['videos'] ?? <String>[],
      };

      try {
        await databases.updateDocument(
          databaseId: _databaseId,
          collectionId: _placesCollection,
          documentId: docId,
          data: data,
        );
        print('✅ $docId');
        ok++;
      } catch (e) {
        if (_isBenignParseError(e)) {
          print('✅ $docId');
          ok++;
        } else {
          print('❌ $docId — $e');
          fail++;
        }
      }
    }
  }

  print('\nDone. ✅ $ok synced   ❌ $fail failed');
}

Future<void> _updateDistrictPlaceCounts(Databases databases) async {
  print('Setting place_count = 4 on all districts...\n');
  var ok = 0;
  var fail = 0;

  for (final district in districts) {
    final id = district['id'] as String;
    try {
      await databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _districtsCollection,
        documentId: id,
        data: {'place_count': 4},
      );
      print('✅ $id');
      ok++;
    } catch (e) {
      if (_isBenignParseError(e)) {
        print('✅ $id');
        ok++;
      } else {
        print('❌ $id — $e');
        fail++;
      }
    }
  }

  print('\nDone. ✅ $ok updated   ❌ $fail failed');
}
