import 'package:ev_lookup/core/error/exceptions.dart';
import 'package:ev_lookup/features/chargers/data/data_sources/charger_remote_data_source.dart';
import 'package:ev_lookup/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('VehicleRemoteDataSource', () {
    test('parses a 200 response and sends the registration', () async {
      late Uri requested;
      final client = MockClient((request) async {
        requested = request.url;
        return http.Response(
          '{"id":"ev-1","make":"Audi","model":"Q8","year":2024,'
          '"batteryKwh":106,"connector":"CCS"}',
          200,
        );
      });

      final vehicle = await VehicleRemoteDataSource(client).lookup('TF24LPO');

      expect(vehicle.connector, 'CCS');
      expect(requested.queryParameters['registration'], 'TF24LPO');
    });

    test('throws NotFoundException with the message on 404', () async {
      final client = MockClient(
        (_) async => http.Response('{"message":"Vehicle not found"}', 404),
      );

      await expectLater(
        VehicleRemoteDataSource(client).lookup('X'),
        throwsA(
          isA<NotFoundException>()
              .having((e) => e.message, 'message', 'Vehicle not found'),
        ),
      );
    });

    test('throws ServerException on other statuses', () async {
      final client = MockClient((_) async => http.Response('', 500));

      await expectLater(
        VehicleRemoteDataSource(client).lookup('X'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('ChargerRemoteDataSource', () {
    test('parses chargers in order', () async {
      final client = MockClient(
        (_) async => http.Response(
          '{"chargers":['
          '{"id":"c1","name":"A","connector":"CCS","powerKw":150,'
          '"freeBays":3,"totalBays":6,"minutes":22,"totalGbp":25.42},'
          '{"id":"c2","name":"B","connector":"CCS","powerKw":160,'
          '"freeBays":2,"totalBays":6,"minutes":19,"totalGbp":27.88}]}',
          200,
        ),
      );

      final chargers = await ChargerRemoteDataSource(client).getChargers();

      expect(chargers.map((c) => c.id), ['c1', 'c2']);
    });

    test('throws ServerException on a non-200 response', () async {
      final client = MockClient((_) async => http.Response('', 503));

      await expectLater(
        ChargerRemoteDataSource(client).getChargers(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
