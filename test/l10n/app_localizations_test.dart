import 'package:ev_lookup/core/error/failure.dart';
import 'package:ev_lookup/l10n/app_localizations.dart';
import 'package:ev_lookup/l10n/failure_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('charger heading handles zero, one and many', () {
    expect(l10n.chargersHeading(0), '0 chargers near you');
    expect(l10n.chargersHeading(1), '1 charger near you');
    expect(l10n.chargersHeading(2), '2 chargers near you');
  });

  test('placeholders format values', () {
    expect(l10n.batteryValue(106), '106 kWh');
    expect(l10n.minutesValue(22), '22 min');
    expect(l10n.chargerDetails(150, 'CCS', 3, 6), '150 kW · CCS · 3 of 6 free');
  });

  test('total is a pound amount with two decimals', () {
    expect(l10n.totalValue(25.42), '£25.42');
    expect(l10n.totalValue(25), '£25.00');
  });

  test('failures map to localized messages', () {
    expect(
      l10n.failureMessage(const NetworkFailure()),
      'Check your connection and try again',
    );
    expect(l10n.failureMessage(const UnknownFailure()), 'Something went wrong');
    expect(
      l10n.failureMessage(const NotFoundFailure('Vehicle not found')),
      'Something went wrong',
    );
  });
}
