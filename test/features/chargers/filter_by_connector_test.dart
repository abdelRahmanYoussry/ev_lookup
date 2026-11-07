import 'package:ev_lookup/features/chargers/domain/entities/charger.dart';
import 'package:ev_lookup/features/chargers/domain/use_cases/get_compatible_chargers.dart';
import 'package:flutter_test/flutter_test.dart';

Charger charger(String id, String connector) => Charger(
      id: id,
      name: 'Charger $id',
      connector: connector,
      powerKw: 50,
      freeBays: 1,
      totalBays: 2,
      minutes: 30,
      totalGbp: 10,
    );

void main() {
  final chargers = [
    charger('c1', 'CCS'),
    charger('c2', 'CCS'),
    charger('c3', 'Type 2'),
  ];

  test('keeps only matching connectors in response order', () {
    final result = filterByConnector(chargers, 'CCS');

    expect(result.map((c) => c.id), ['c1', 'c2']);
  });

  test('excludes Type 2 chargers for a CCS vehicle', () {
    final result = filterByConnector(chargers, 'CCS');

    expect(result.any((c) => c.connector == 'Type 2'), isFalse);
  });

  test('matches exactly, so a different case does not match', () {
    expect(filterByConnector(chargers, 'ccs'), isEmpty);
  });
}
