import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_use_case.dart';
import '../entities/vehicle.dart';
import '../repositories/base_vehicle_repository.dart';

class LookupVehicle extends BaseUseCase<Vehicle, String> {
  final BaseVehicleRepository repository;

  LookupVehicle(this.repository);

  @override
  Future<Either<Failure, Vehicle>> call(String registration) =>
      repository.lookup(registration);
}
