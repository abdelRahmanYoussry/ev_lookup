import 'package:ev_lookup/core/error/failure.dart';
import 'package:ev_lookup/features/chargers/data/data_sources/charger_remote_data_source.dart';
import 'package:ev_lookup/features/chargers/data/repositories/charger_repository.dart';
import 'package:ev_lookup/features/chargers/domain/use_cases/get_compatible_chargers.dart';
import 'package:ev_lookup/mock/mock_transport.dart';
import 'package:flutter_test/flutter_test.dart';

GetCompatibleChargers useCase(MockTransport transport) => GetCompatibleChargers(
  ChargerRepository(ChargerRemoteDataSource(transport)),
);

void main() {
  test('CCS returns c1 then c2 and excludes c3', () async {
    final result = await useCase(MockTransport())('CCS');

    final ids = result.getOrElse(() => []).map((c) => c.id).toList();
    expect(ids, ['c1', 'c2']);
  });

  test('failChargersOnce returns a NetworkFailure', () async {
    final result = await useCase(MockTransport(failChargersOnce: true))('CCS');

    final failure = result.fold((f) => f, (_) => null);
    expect(failure, isA<NetworkFailure>());
  });
}
