import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ev_lookup/core/error/exceptions.dart';
import 'package:ev_lookup/core/error/failure.dart';
import 'package:ev_lookup/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:ev_lookup/features/vehicle/data/models/vehicle_model.dart';
import 'package:ev_lookup/features/vehicle/data/repositories/vehicle_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockVehicleDataSource extends Mock
    implements BaseVehicleRemoteDataSource {}

void main() {
  late MockVehicleDataSource dataSource;
  late VehicleRepository repository;

  setUp(() {
    dataSource = MockVehicleDataSource();
    repository = VehicleRepository(dataSource);
  });

  Failure? failureOf(Either<Failure, Object> result) =>
      result.fold((failure) => failure, (_) => null);

  test('returns the vehicle on success', () async {
    const model = VehicleModel(
      id: 'ev-1',
      make: 'Audi',
      model: 'Q8',
      year: 2024,
      batteryKwh: 106,
      connector: 'CCS',
    );
    when(() => dataSource.lookup('TF24LPO')).thenAnswer((_) async => model);

    final result = await repository.lookup('TF24LPO');

    expect(result, const Right(model));
  });

  test('maps NotFoundException to NotFoundFailure with its message', () async {
    when(() => dataSource.lookup(any()))
        .thenThrow(const NotFoundException('Vehicle not found'));

    final result = await repository.lookup('X');

    expect(failureOf(result), const NotFoundFailure('Vehicle not found'));
  });

  test('maps http.ClientException to NetworkFailure', () async {
    when(() => dataSource.lookup(any())).thenThrow(http.ClientException('x'));

    expect(failureOf(await repository.lookup('X')), isA<NetworkFailure>());
  });

  test('maps SocketException to NetworkFailure', () async {
    when(() => dataSource.lookup(any()))
        .thenThrow(const SocketException('x'));

    expect(failureOf(await repository.lookup('X')), isA<NetworkFailure>());
  });

  test('maps ServerException to UnknownFailure', () async {
    when(() => dataSource.lookup(any())).thenThrow(const ServerException(500));

    expect(failureOf(await repository.lookup('X')), isA<UnknownFailure>());
  });

  test('maps parsing errors to UnknownFailure', () async {
    when(() => dataSource.lookup(any())).thenThrow(const FormatException());

    expect(failureOf(await repository.lookup('X')), isA<UnknownFailure>());
  });
}
