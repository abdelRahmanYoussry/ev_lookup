import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _vehicle = {
  'id': 'ev-1',
  'make': 'Audi',
  'model': 'Q8 e-tron 55 quattro',
  'year': 2024,
  'batteryKwh': 106,
  'connector': 'CCS',
};

const _chargers = [
  {
    'id': 'c1',
    'name': 'GRIDSERVE Braintree',
    'connector': 'CCS',
    'powerKw': 150,
    'freeBays': 3,
    'totalBays': 6,
    'minutes': 22,
    'totalGbp': 25.42,
  },
  {
    'id': 'c2',
    'name': 'Osprey Galleys Corner',
    'connector': 'CCS',
    'powerKw': 160,
    'freeBays': 2,
    'totalBays': 6,
    'minutes': 19,
    'totalGbp': 27.88,
  },
  {
    'id': 'c3',
    'name': 'bp pulse Braintree',
    'connector': 'Type 2',
    'powerKw': 22,
    'freeBays': 2,
    'totalBays': 6,
    'minutes': 60,
    'totalGbp': 20.00,
  },
];

class MockTransport extends MockClient {
  MockTransport({
    bool failLookupOnce = false,
    bool failChargersOnce = false,
    bool emptyChargers = false,
  }) : super(_handler(failLookupOnce, failChargersOnce, emptyChargers));

  static Future<http.Response> Function(http.Request) _handler(
    bool failLookupOnce,
    bool failChargersOnce,
    bool emptyChargers,
  ) {
    var lookupFailurePending = failLookupOnce;
    var chargersFailurePending = failChargersOnce;

    return (request) async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final url = request.url;

      if (url.path == '/vehicles/lookup') {
        if (lookupFailurePending) {
          lookupFailurePending = false;
          throw http.ClientException('Connection failed', url);
        }
        final registration = url.queryParameters['registration'] ?? '';
        if (registration == 'TF24LPO') return _json(200, _vehicle);
        return _json(404, {'message': 'Vehicle not found'});
      }

      if (url.path == '/chargers') {
        if (chargersFailurePending) {
          chargersFailurePending = false;
          throw http.ClientException('Connection failed', url);
        }
        return _json(200, {'chargers': emptyChargers ? [] : _chargers});
      }

      return _json(404, {'message': 'Not found'});
    };
  }

  static http.Response _json(int status, Object body) {
    return http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json'},
    );
  }
}
