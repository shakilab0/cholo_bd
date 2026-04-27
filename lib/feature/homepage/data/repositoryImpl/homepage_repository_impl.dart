import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/feature/homepage/data/dataSource/homepage_remote_data_source.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/repository/homepage_repository.dart';

class HomepageRepositoryImpl implements HomepageRepository {
  final HomepageRemoteDataSource _remote;

  HomepageRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<DistrictModel>>> getDistricts() async {
    try {
      final remote = await _remote.fetchDistricts();
      await saveDistrictsToCache(remote.map((d) => d.toMap()).toList());
      return Right(remote);
    } catch (_) {
      final cached = getDistrictsFromCache();
      if (cached.isNotEmpty) {
        return Right(cached.map(DistrictModel.fromMap).toList());
      }
      return Right(seedDistricts);
    }
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getFeaturedPlaces() async {
    try {
      final places = await _remote.fetchFeaturedPlaces();
      return Right(places);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getPlacesByDistrict(
      String districtId) async {
    try {
      final remote = await _remote.fetchPlacesByDistrict(districtId);
      await savePlacesToCache(
          districtId, remote.map((p) => p.toMap()).toList());
      return Right(remote);
    } catch (_) {
      final cached = getPlacesFromCache(districtId);
      if (cached.isNotEmpty) {
        return Right(cached.map(PlaceModel.fromMap).toList());
      }
      return Left(const NetworkFailure());
    }
  }
}
