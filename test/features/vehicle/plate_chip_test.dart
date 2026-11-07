import 'package:ev_lookup/features/vehicle/presentation/widgets/plate_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('puts a space before the last three characters', () {
    expect(formatPlate('TF24LPO'), 'TF24 LPO');
  });

  test('leaves short values unchanged', () {
    expect(formatPlate('AB1'), 'AB1');
  });
}
