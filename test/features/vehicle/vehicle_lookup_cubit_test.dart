import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ev_lookup/core/error/failure.dart';
import 'package:ev_lookup/features/vehicle/domain/entities/vehicle.dart';
import 'package:ev_lookup/features/vehicle/domain/use_cases/lookup_vehicle.dart';
import 'package:ev_lookup/features/vehicle/presentation/cubit/vehicle_lookup_cubit.dart';
import 'package:ev_lookup/features/vehicle/presentation/cubit/vehicle_lookup_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLookupVehicle extends Mock implements LookupVehicle {}

const vehicle = Vehicle(
  id: 'ev-1',
  make: 'Audi',
  model: 'Q8 e-tron 55 quattro',
  year: 2024,
  batteryKwh: 106,
  connector: 'CCS',
);

void main() {
  late MockLookupVehicle lookupVehicle;

  setUp(() {
    lookupVehicle = MockLookupVehicle();
  });

  void stub(Either<Failure, Vehicle> result, {String registration = 'TF24LPO'}) {
    when(() => lookupVehicle(registration)).thenAnswer((_) async => result);
  }

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'emits loading then success with the normalised registration',
    setUp: () => stub(const Right(vehicle)),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => cubit.lookup('tf24 lpo'),
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupSuccess(vehicle, 'TF24LPO'),
    ],
    verify: (_) => verify(() => lookupVehicle('TF24LPO')).called(1),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'emits notFound with the failure message',
    setUp: () => stub(
      const Left(NotFoundFailure('Vehicle not found')),
      registration: 'AB12CDE',
    ),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => cubit.lookup('ab12 cde'),
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupNotFound('Vehicle not found'),
    ],
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'emits failed on a network failure',
    setUp: () => stub(const Left(NetworkFailure('No connection'))),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => cubit.lookup('TF24LPO'),
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupFailed('No connection'),
    ],
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'emits failed on an unknown failure',
    setUp: () => stub(const Left(UnknownFailure('Something went wrong'))),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => cubit.lookup('TF24LPO'),
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupFailed('Something went wrong'),
    ],
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'blank input emits a validation error and sends no request',
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => cubit.lookup('   '),
    expect: () => const [VehicleLookupValidationError('Enter your registration')],
    verify: (_) => verifyNever(() => lookupVehicle(any())),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'ignores a second lookup while loading',
    setUp: () => when(() => lookupVehicle('TF24LPO')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const Right(vehicle);
    }),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => Future.wait([cubit.lookup('TF24LPO'), cubit.lookup('TF24LPO')]),
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupSuccess(vehicle, 'TF24LPO'),
    ],
    verify: (_) => verify(() => lookupVehicle('TF24LPO')).called(1),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'retry repeats the last submitted registration',
    setUp: () {
      var calls = 0;
      when(() => lookupVehicle('TF24LPO')).thenAnswer((_) async {
        final Either<Failure, Vehicle> result = calls++ == 0
            ? const Left(NetworkFailure('No connection'))
            : const Right(vehicle);
        return result;
      });
    },
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) async {
      await cubit.lookup('tf24 lpo');
      await cubit.retry();
    },
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupFailed('No connection'),
      VehicleLookupLoading(),
      VehicleLookupSuccess(vehicle, 'TF24LPO'),
    ],
    verify: (_) => verify(() => lookupVehicle('TF24LPO')).called(2),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'retry keeps the last registration after a blank submission',
    setUp: () => stub(const Left(NetworkFailure('No connection'))),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) async {
      await cubit.lookup('TF24LPO');
      await cubit.lookup('');
      await cubit.retry();
    },
    verify: (_) => verify(() => lookupVehicle('TF24LPO')).called(2),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'retry does nothing before any registration was submitted',
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => cubit.retry(),
    expect: () => const <VehicleLookupState>[],
    verify: (_) => verifyNever(() => lookupVehicle(any())),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'retry is ignored while loading',
    setUp: () => when(() => lookupVehicle('TF24LPO')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const Right(vehicle);
    }),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) => Future.wait([cubit.lookup('TF24LPO'), cubit.retry()]),
    verify: (_) => verify(() => lookupVehicle('TF24LPO')).called(1),
  );

  blocTest<VehicleLookupCubit, VehicleLookupState>(
    'reset returns to initial',
    setUp: () => stub(const Right(vehicle)),
    build: () => VehicleLookupCubit(lookupVehicle),
    act: (cubit) async {
      await cubit.lookup('TF24LPO');
      cubit.reset();
    },
    expect: () => const [
      VehicleLookupLoading(),
      VehicleLookupSuccess(vehicle, 'TF24LPO'),
      VehicleLookupInitial(),
    ],
  );

  test('does not emit when closed while a request is in flight', () async {
    final pending = Completer<Either<Failure, Vehicle>>();
    when(() => lookupVehicle('TF24LPO')).thenAnswer((_) => pending.future);
    final cubit = VehicleLookupCubit(lookupVehicle);
    final states = <VehicleLookupState>[];
    final subscription = cubit.stream.listen(states.add);

    final lookup = cubit.lookup('TF24LPO');
    await cubit.close();
    pending.complete(const Right(vehicle));

    await expectLater(lookup, completes);
    expect(states, const [VehicleLookupLoading()]);
    await subscription.cancel();
  });
}
