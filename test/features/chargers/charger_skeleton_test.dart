import 'package:ev_lookup/features/chargers/presentation/widgets/charger_skeleton.dart';
import 'package:ev_lookup/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('skeleton shimmers and disposes its animation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: ChargerSkeleton()),
      ),
    );

    expect(find.byType(ShaderMask), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(),
      ),
    );

    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
