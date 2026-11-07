import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle.dart';

abstract class BaseVehicleRepository {
  Future<Either<Failure, Vehicle>> lookup(String registration);
}
