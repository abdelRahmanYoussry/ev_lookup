import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<Either<Failure, T>> call(Parameters parameters);
}
