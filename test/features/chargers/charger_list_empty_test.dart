import 'package:bloc_test/bloc_test.dart';
import 'package:ev_lookup/features/chargers/presentation/cubit/chargers_cubit.dart';
import 'package:ev_lookup/features/chargers/presentation/cubit/chargers_state.dart';
import 'package:ev_lookup/features/chargers/presentation/screens/charger_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockChargersCubit extends MockCubit<ChargersState>
    implements ChargersCubit {}

void main() {
  testWidgets('empty chargers state explains and lets the user go back', (
    tester,
  ) async {
    final cubit = MockChargersCubit();
    whenListen(
      cubit,
      const Stream<ChargersState>.empty(),
      initialState: const ChargersEmpty(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => Scaffold(
                body: TextButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder:
                              (_) => BlocProvider<ChargersCubit>.value(
                                value: cubit,
                                child: const ChargerListScreen(),
                              ),
                        ),
                      ),
                  child: const Text('open'),
                ),
              ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('0 chargers near you'), findsOneWidget);
    expect(find.text('No compatible chargers'), findsOneWidget);
    expect(
      find.text('We could not find any chargers that fit your car.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();

    expect(find.text('open'), findsOneWidget);
    expect(find.byType(ChargerListScreen), findsNothing);
  });
}
