import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/useCase/use_case.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/repository/homepage_repository.dart';

class GetPlacesByDistrictUseCase
    implements UseCase<List<PlaceModel>, String> {
  final HomepageRepository _repository;
  GetPlacesByDistrictUseCase(this._repository);

  @override
  Future<Either<Failure, List<PlaceModel>>> execute(String districtId) =>
      _repository.getPlacesByDistrict(districtId);
}
