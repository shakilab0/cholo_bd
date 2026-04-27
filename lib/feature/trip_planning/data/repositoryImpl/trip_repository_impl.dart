import 'dart:convert';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:cholo_bd/config/constant/apwrite_constant.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/transport_option_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final _uuid = const Uuid();
  late final Databases _db;

  TripRepositoryImpl() {
    _db = AppWriteProvider().databases;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _tripToAppwriteMap(TripModel trip) => {
        'name': trip.name,
        'district_id': trip.districtId,
        'district_name': trip.districtName,
        'places_json':
            jsonEncode(trip.places.map((p) => p.toMap()).toList()),
        'transport': trip.transport.id,
        'trip_date': trip.tripDate.millisecondsSinceEpoch,
        'created_at': trip.createdAt.millisecondsSinceEpoch,
        'status': trip.status.name,
        'user_id': '',
        'notes': trip.notes ?? '',
      };

  TripModel _fromAppwriteDoc(Map<String, dynamic> data, String docId) {
    final placesRaw =
        jsonDecode(data['places_json'] as String? ?? '[]') as List;
    return TripModel(
      id: docId,
      name: data['name'] ?? '',
      districtId: data['district_id'] ?? '',
      districtName: data['district_name'] ?? '',
      places: placesRaw
          .map((p) => PlaceModel.fromMap(Map<String, dynamic>.from(p)))
          .toList(),
      transport: TransportOptionModelHelper.fromId(data['transport'] ?? 'bus'),
      tripDate:
          DateTime.fromMillisecondsSinceEpoch(data['trip_date'] ?? 0),
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(data['created_at'] ?? 0),
      status: TripStatus.values.firstWhere(
        (s) => s.name == (data['status'] ?? 'upcoming'),
        orElse: () => TripStatus.upcoming,
      ),
      notes: data['notes'],
    );
  }

  // ── CRUD ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<TripModel>>> getTrips() async {
    // Try Appwrite first
    try {
      final result = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tripsCollection,
      );
      final trips = result.documents
          .map((doc) => _fromAppwriteDoc(doc.data, doc.$id))
          .toList();
      // Sync to local cache
      await saveTripsToCache(trips.map((t) => t.toMap()).toList());
      return Right(trips);
    } catch (e) {
      log('getTrips Appwrite error: $e — using local cache');
    }

    // Fallback to Hive
    try {
      final cached = getTripsFromCache();
      return Right(cached.map(TripModel.fromMap).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripModel>> createTrip(TripModel trip) async {
    final id = _uuid.v4();
    final withId = TripModel(
      id: id,
      name: trip.name,
      districtId: trip.districtId,
      districtName: trip.districtName,
      places: trip.places,
      transport: trip.transport,
      tripDate: trip.tripDate,
      createdAt: DateTime.now(),
      status: TripStatus.upcoming,
      notes: trip.notes,
    );

    // Save locally first (offline-first)
    try {
      final current = getTripsFromCache();
      current.add(withId.toMap());
      await saveTripsToCache(current);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }

    // Try Appwrite in background (don't fail if offline)
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tripsCollection,
        documentId: id,
        data: _tripToAppwriteMap(withId),
      );
      log('Trip synced to Appwrite: ${withId.name}');
    } catch (e) {
      log('Trip Appwrite sync failed (offline?): $e');
    }

    return Right(withId);
  }

  @override
  Future<Either<Failure, Unit>> updateTrip(TripModel trip) async {
    // Update local cache
    try {
      final current = getTripsFromCache();
      final index = current.indexWhere((m) => m['id'] == trip.id);
      if (index != -1) current[index] = trip.toMap();
      await saveTripsToCache(current);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }

    // Try Appwrite
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tripsCollection,
        documentId: trip.id,
        data: _tripToAppwriteMap(trip),
      );
    } catch (e) {
      log('updateTrip Appwrite sync failed: $e');
    }

    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteTrip(String tripId) async {
    // Delete from local cache
    try {
      final current = getTripsFromCache();
      current.removeWhere((m) => m['id'] == tripId);
      await saveTripsToCache(current);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }

    // Try Appwrite
    try {
      await _db.deleteDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tripsCollection,
        documentId: tripId,
      );
    } catch (e) {
      log('deleteTrip Appwrite sync failed: $e');
    }

    return const Right(unit);
  }
}

/// Helper to reconstruct TransportOptionModel from its id string
class TransportOptionModelHelper {
  static TransportOptionModel fromId(String id) {
    return bangladeshTransports.firstWhere(
      (t) => t.id == id,
      orElse: () => bangladeshTransports.first,
    );
  }
}
