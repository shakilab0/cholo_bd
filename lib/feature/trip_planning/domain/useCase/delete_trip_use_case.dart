import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/core/useCase/use_case.dart';
import 'package:cholo_bd/feature/trip_planning/domain/repository/trip_repository.dart';

class DeleteTripUseCase implements UseCase<Unit, String> {
  final TripRepository _repository;
  DeleteTripUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> execute(String tripId) =>
      _repository.deleteTrip(tripId);
}
