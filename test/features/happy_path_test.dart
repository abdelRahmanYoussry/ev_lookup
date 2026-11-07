import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('tf24 lpo reaches the two CCS chargers', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'tf24 lpo');
    await tester.tap(find.text('Find my EV'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Is this your car?'), findsOneWidget);
    expect(find.text('Audi Q8 e-tron 55 quattro'), findsOneWidget);
    expect(find.text('TF24 LPO'), findsOneWidget);
    expect(find.text('106 kWh'), findsOneWidget);

    await tester.tap(find.text('Yes, add my EV'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('2 chargers near you'), findsOneWidget);
    expect(find.text('Charging 40% → 80%'), findsOneWidget);
    expect(find.text('GRIDSERVE Braintree'), findsOneWidget);
    expect(find.text('Osprey Galleys Corner'), findsOneWidget);
    expect(find.text('bp pulse Braintree'), findsNothing);
    expect(find.text('150 kW · CCS · 3 of 6 free'), findsOneWidget);
    expect(find.text('£25.42'), findsOneWidget);
  });

  testWidgets('Not my car returns to a clean registration screen', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'TF24LPO');
    await tester.tap(find.text('Find my EV'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Not my car'));
    await tester.pumpAndSettle();

    expect(find.text('Add your EV'), findsOneWidget);
    expect(
      find.text('Check the plate on the back of your car.'),
      findsOneWidget,
    );
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('registration screen does not overflow with the keyboard open', (
    tester,
  ) async {
    await pumpApp(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 1000);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Find my EV'), findsOneWidget);
  });
}
