import 'dart:convert';

import 'package:ev_lookup/core/constants.dart';
import 'package:ev_lookup/mock/mock_transport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

Uri lookup(String registration) =>
    Uri.parse('$baseUrl/vehicles/lookup?registration=$registration');

final chargersUri = Uri.parse('$baseUrl/chargers');

void main() {
  test('lookup returns the vehicle for TF24LPO', () async {
    final response = await MockTransport().get(lookup('TF24LPO'));

    expect(response.statusCode, 200);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    expect(body['make'], 'Audi');
    expect(body['connector'], 'CCS');
  });

  test('lookup returns 404 with a message for other registrations', () async {
    final response = await MockTransport().get(lookup('AB12CDE'));

    expect(response.statusCode, 404);
    expect(jsonDecode(response.body), {'message': 'Vehicle not found'});
  });

  test('chargers come back in order', () async {
    final response = await MockTransport().get(chargersUri);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final ids = (body['chargers'] as List).map((c) => c['id']).toList();
    expect(ids, ['c1', 'c2', 'c3']);
  });

  test('emptyChargers returns an empty list', () async {
    final response = await MockTransport(emptyChargers: true).get(chargersUri);

    expect(jsonDecode(response.body), {'chargers': []});
  });

  test('failLookupOnce fails only the first lookup', () async {
    final client = MockTransport(failLookupOnce: true);

    await expectLater(
      client.get(lookup('TF24LPO')),
      throwsA(isA<http.ClientException>()),
    );
    final second = await client.get(lookup('TF24LPO'));
    expect(second.statusCode, 200);
  });

  test('failChargersOnce fails only the first chargers request', () async {
    final client = MockTransport(failChargersOnce: true);

    await expectLater(
      client.get(chargersUri),
      throwsA(isA<http.ClientException>()),
    );
    final second = await client.get(chargersUri);
    expect(second.statusCode, 200);
  });
}
