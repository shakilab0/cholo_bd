import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/useCase/use_case.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/domain/repository/homepage_repository.dart';

class GetDistrictsUseCase implements NoParamsUseCase<List<DistrictModel>> {
  final HomepageRepository _repository;
  GetDistrictsUseCase(this._repository);

  @override
  Future<Either<Failure, List<DistrictModel>>> execute() =>
      _repository.getDistricts();
}
