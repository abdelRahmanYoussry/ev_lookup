import 'package:ev_lookup/features/chargers/presentation/widgets/charger_skeleton.dart';
import 'package:ev_lookup/features/chargers/presentation/widgets/charging_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  group('registration', () {
    testWidgets('blank input shows an error without Retry', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Find my EV'));
      await tester.pump();

      expect(find.text('Enter your registration'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('not found shows the message without Retry, then recovers',
        (tester) async {
      await pumpApp(tester);

      await submitRegistration(tester, 'ab12 cde');

      expect(find.text('Vehicle not found'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);

      await submitRegistration(tester, 'tf24 lpo');

      expect(find.text('Is this your car?'), findsOneWidget);
    });

    testWidgets('failure shows Retry that repeats the submitted registration',
        (tester) async {
      await pumpApp(tester, failLookupOnce: true);

      await submitRegistration(tester, 'tf24 lpo');

      expect(find.text('Check your connection and try again'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Is this your car?'), findsOneWidget);
      expect(find.text('TF24 LPO'), findsOneWidget);
    });
  });

  group('charger list', () {
    testWidgets('shows skeleton cards while loading', (tester) async {
      await pumpApp(tester);
      await submitRegistration(tester, 'tf24 lpo');

      await tester.tap(find.text('Yes, add my EV'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Chargers near you'), findsOneWidget);
      expect(find.byType(ChargerSkeleton), findsNWidgets(3));

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.byType(ChargerSkeleton), findsNothing);
    });

    testWidgets('failure shows the message and Retry recovers',
        (tester) async {
      await pumpApp(tester, failChargersOnce: true);
      await submitRegistration(tester, 'tf24 lpo');
      await openChargers(tester);

      expect(find.text('Could not load chargers'), findsOneWidget);
      expect(find.text('Check your connection and try again'), findsOneWidget);
      expect(find.byType(ChargingSummaryCard), findsNothing);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('2 chargers near you'), findsOneWidget);
    });

    testWidgets('empty list shows a message and Go back returns',
        (tester) async {
      await pumpApp(tester, emptyChargers: true);
      await submitRegistration(tester, 'tf24 lpo');
      await openChargers(tester);

      expect(find.text('0 chargers near you'), findsOneWidget);
      expect(find.text('No compatible chargers'), findsOneWidget);
      expect(find.byType(ChargingSummaryCard), findsNothing);

      await tester.tap(find.text('Go back'));
      await tester.pumpAndSettle();

      expect(find.text('Is this your car?'), findsOneWidget);
    });
  });
}
