import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

abstract class HomepageRepository {
  Future<Either<Failure, List<DistrictModel>>> getDistricts();
  Future<Either<Failure, List<PlaceModel>>> getFeaturedPlaces();
  Future<Either<Failure, List<PlaceModel>>> getPlacesByDistrict(
      String districtId);
}
