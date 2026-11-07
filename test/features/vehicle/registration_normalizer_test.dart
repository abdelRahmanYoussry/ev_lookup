import 'package:ev_lookup/features/vehicle/domain/registration_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('removes spaces and uppercases', () {
    expect(RegistrationNormalizer.normalize('tf24 lpo'), 'TF24LPO');
  });

  test('removes every kind of whitespace', () {
    expect(RegistrationNormalizer.normalize(' tf 24\tlpo\n'), 'TF24LPO');
  });

  test('leaves an already normalised value unchanged', () {
    expect(RegistrationNormalizer.normalize('TF24LPO'), 'TF24LPO');
  });

  test('blank input becomes empty', () {
    expect(RegistrationNormalizer.normalize('   '), '');
  });
}
