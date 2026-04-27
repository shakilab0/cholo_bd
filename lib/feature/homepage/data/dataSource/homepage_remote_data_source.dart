import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:cholo_bd/config/constant/apwrite_constant.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class HomepageRemoteDataSource {
  final AppWriteProvider _provider;

  HomepageRemoteDataSource(this._provider);

  Future<List<DistrictModel>> fetchDistricts() async {
    try {
      final result = await _provider.databases.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.districtsCollection,
      );
      return result.documents
          .map((doc) => DistrictModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      log('fetchDistricts error: $e — using seed data');
      return seedDistricts;
    }
  }

  Future<List<PlaceModel>> fetchPlacesByDistrict(String districtId) async {
    try {
      final result = await _provider.databases.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.placesCollection,
        queries: [Query.equal('district_id', districtId)],
      );
      return result.documents
          .map((doc) => PlaceModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      log('fetchPlacesByDistrict error: $e');
      return [];
    }
  }

  Future<List<PlaceModel>> fetchFeaturedPlaces() async {
    try {
      final result = await _provider.databases.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.placesCollection,
        queries: [Query.orderDesc('rating'), Query.limit(6)],
      );
      return result.documents
          .map((doc) => PlaceModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      log('fetchFeaturedPlaces error: $e');
      return [];
    }
  }
}
