import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ev_lookup/core/error/failure.dart';
import 'package:ev_lookup/features/chargers/domain/entities/charger.dart';
import 'package:ev_lookup/features/chargers/domain/use_cases/get_compatible_chargers.dart';
import 'package:ev_lookup/features/chargers/presentation/cubit/chargers_cubit.dart';
import 'package:ev_lookup/features/chargers/presentation/cubit/chargers_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCompatibleChargers extends Mock implements GetCompatibleChargers {}

const first = Charger(
  id: 'c1',
  name: 'GRIDSERVE Braintree',
  connector: 'CCS',
  powerKw: 150,
  freeBays: 3,
  totalBays: 6,
  minutes: 22,
  totalGbp: 25.42,
);

const second = Charger(
  id: 'c2',
  name: 'Osprey Galleys Corner',
  connector: 'CCS',
  powerKw: 160,
  freeBays: 2,
  totalBays: 6,
  minutes: 19,
  totalGbp: 27.88,
);

void main() {
  late MockGetCompatibleChargers getChargers;

  setUp(() {
    getChargers = MockGetCompatibleChargers();
  });

  test('starts in the loading state', () {
    expect(ChargersCubit(getChargers).state, const ChargersLoading());
  });

  blocTest<ChargersCubit, ChargersState>(
    'emits loaded with the chargers in order',
    setUp:
        () => when(
          () => getChargers('CCS'),
        ).thenAnswer((_) async => const Right([first, second])),
    build: () => ChargersCubit(getChargers),
    act: (cubit) => cubit.load('CCS'),
    expect:
        () => const [
          ChargersLoading(),
          ChargersLoaded([first, second]),
        ],
  );

  blocTest<ChargersCubit, ChargersState>(
    'emits empty when nothing is compatible',
    setUp:
        () => when(
          () => getChargers('CCS'),
        ).thenAnswer((_) async => const Right(<Charger>[])),
    build: () => ChargersCubit(getChargers),
    act: (cubit) => cubit.load('CCS'),
    expect: () => const [ChargersLoading(), ChargersEmpty()],
  );

  blocTest<ChargersCubit, ChargersState>(
    'emits failure with the failure message',
    setUp:
        () => when(
          () => getChargers('CCS'),
        ).thenAnswer((_) async => const Left(NetworkFailure('No connection'))),
    build: () => ChargersCubit(getChargers),
    act: (cubit) => cubit.load('CCS'),
    expect: () => const [ChargersLoading(), ChargersFailure('No connection')],
  );

  blocTest<ChargersCubit, ChargersState>(
    'retry reloads with the same connector',
    setUp: () {
      var calls = 0;
      when(() => getChargers('CCS')).thenAnswer((_) async {
        final Either<Failure, List<Charger>> result =
            calls++ == 0
                ? const Left(NetworkFailure('No connection'))
                : const Right([first, second]);
        return result;
      });
    },
    build: () => ChargersCubit(getChargers),
    act: (cubit) async {
      await cubit.load('CCS');
      await cubit.retry();
    },
    expect:
        () => const [
          ChargersLoading(),
          ChargersFailure('No connection'),
          ChargersLoading(),
          ChargersLoaded([first, second]),
        ],
    verify: (_) => verify(() => getChargers('CCS')).called(2),
  );

  blocTest<ChargersCubit, ChargersState>(
    'retry does nothing before the first load',
    build: () => ChargersCubit(getChargers),
    act: (cubit) => cubit.retry(),
    expect: () => const <ChargersState>[],
    verify: (_) => verifyNever(() => getChargers(any())),
  );

  test('does not emit when closed while a request is in flight', () async {
    final pending = Completer<Either<Failure, List<Charger>>>();
    when(() => getChargers('CCS')).thenAnswer((_) => pending.future);
    final cubit = ChargersCubit(getChargers);
    final states = <ChargersState>[];
    final subscription = cubit.stream.listen(states.add);

    final loading = cubit.load('CCS');
    await cubit.close();
    pending.complete(const Right([first, second]));

    await expectLater(loading, completes);
    expect(states, const [ChargersLoading()]);
    await subscription.cancel();
  });
}
