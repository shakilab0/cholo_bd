import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/useCase/use_case.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/repository/homepage_repository.dart';

class GetFeaturedPlacesUseCase implements NoParamsUseCase<List<PlaceModel>> {
  final HomepageRepository _repository;
  GetFeaturedPlacesUseCase(this._repository);

  @override
  Future<Either<Failure, List<PlaceModel>>> execute() =>
      _repository.getFeaturedPlaces();
}
