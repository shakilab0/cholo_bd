import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';

abstract class TripRepository {
  Future<Either<Failure, List<TripModel>>> getTrips();
  Future<Either<Failure, TripModel>> createTrip(TripModel trip);
  Future<Either<Failure, Unit>> updateTrip(TripModel trip);
  Future<Either<Failure, Unit>> deleteTrip(String tripId);
}
