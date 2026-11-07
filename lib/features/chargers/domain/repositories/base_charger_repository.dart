import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/charger.dart';

abstract class BaseChargerRepository {
  Future<Either<Failure, List<Charger>>> getChargers();
}
