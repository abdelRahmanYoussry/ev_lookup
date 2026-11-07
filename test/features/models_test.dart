import 'package:ev_lookup/features/chargers/data/models/charger_model.dart';
import 'package:ev_lookup/features/vehicle/data/models/vehicle_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VehicleModel parses the lookup response', () {
    final model = VehicleModel.fromJson({
      'id': 'ev-1',
      'make': 'Audi',
      'model': 'Q8 e-tron 55 quattro',
      'year': 2024,
      'batteryKwh': 106,
      'connector': 'CCS',
    });

    expect(model.make, 'Audi');
    expect(model.model, 'Q8 e-tron 55 quattro');
    expect(model.year, 2024);
    expect(model.batteryKwh, 106);
    expect(model.connector, 'CCS');
  });

  test('ChargerModel parses a charger', () {
    final model = ChargerModel.fromJson({
      'id': 'c1',
      'name': 'GRIDSERVE Braintree',
      'connector': 'CCS',
      'powerKw': 150,
      'freeBays': 3,
      'totalBays': 6,
      'minutes': 22,
      'totalGbp': 25.42,
    });

    expect(model.name, 'GRIDSERVE Braintree');
    expect(model.powerKw, 150);
    expect(model.freeBays, 3);
    expect(model.totalBays, 6);
    expect(model.minutes, 22);
    expect(model.totalGbp, 25.42);
  });

  test('ChargerModel accepts a whole number price', () {
    final model = ChargerModel.fromJson({
      'id': 'c3',
      'name': 'bp pulse Braintree',
      'connector': 'Type 2',
      'powerKw': 22,
      'freeBays': 2,
      'totalBays': 6,
      'minutes': 60,
      'totalGbp': 20,
    });

    expect(model.totalGbp, 20.0);
  });

  test('a missing key throws', () {
    expect(() => VehicleModel.fromJson({'id': 'ev-1'}), throwsA(anything));
  });
}
