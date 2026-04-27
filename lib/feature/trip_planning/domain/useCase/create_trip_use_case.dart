import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/useCase/use_case.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/repository/trip_repository.dart';

class CreateTripUseCase implements UseCase<TripModel, TripModel> {
  final TripRepository _repository;
  CreateTripUseCase(this._repository);

  @override
  Future<Either<Failure, TripModel>> execute(TripModel params) =>
      _repository.createTrip(params);
}
