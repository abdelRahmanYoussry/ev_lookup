import 'package:ev_lookup/core/di/services_locator.dart';
import 'package:ev_lookup/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  bool failLookupOnce = false,
  bool failChargersOnce = false,
  bool emptyChargers = false,
}) async {
  await sl.reset();
  setupServiceLocator(
    failLookupOnce: failLookupOnce,
    failChargersOnce: failChargersOnce,
    emptyChargers: emptyChargers,
  );

  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const MaterialApp(
      initialRoute: AppRoutes.registration,
      onGenerateRoute: AppRouter.onGenerateRoute,
    ),
  );
}

Future<void> submitRegistration(
  WidgetTester tester,
  String registration,
) async {
  await tester.enterText(find.byType(TextField), registration);
  await tester.tap(find.text('Find my EV'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

Future<void> openChargers(WidgetTester tester) async {
  await tester.tap(find.text('Yes, add my EV'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}
