import 'package:dartz/dartz.dart';
import 'package:cholo_bd/core/failure/failure.dart';

abstract class UseCase<Output, Input> {
  Future<Either<Failure, Output>> execute(Input params);
}

abstract class NoParamsUseCase<Output> {
  Future<Either<Failure, Output>> execute();
}
