import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_use_case.dart';
import '../entities/charger.dart';
import '../repositories/base_charger_repository.dart';

class GetCompatibleChargers extends BaseUseCase<List<Charger>, String> {
  final BaseChargerRepository repository;

  GetCompatibleChargers(this.repository);

  @override
  Future<Either<Failure, List<Charger>>> call(String connector) async {
    final result = await repository.getChargers();
    return result.map((chargers) => filterByConnector(chargers, connector));
  }
}

List<Charger> filterByConnector(List<Charger> chargers, String connector) =>
    chargers.where((charger) => charger.connector == connector).toList();
