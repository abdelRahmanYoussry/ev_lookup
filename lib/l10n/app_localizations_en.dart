// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EV Lookup';

  @override
  String get registrationTitle => 'Add your EV';

  @override
  String get registrationStep => 'STEP 1 OF 2';

  @override
  String get registrationHeading => 'What\'s your registration?';

  @override
  String get registrationSubtitle => 'We look up your car so charging shows only chargers that fit, with real time and cost.';

  @override
  String get registrationHelper => 'Check the plate on the back of your car.';

  @override
  String get findMyEv => 'Find my EV';

  @override
  String get retry => 'Retry';

  @override
  String get enterRegistration => 'Enter your registration';

  @override
  String get vehicleNotFound => 'Vehicle not found';

  @override
  String get networkError => 'Check your connection and try again';

  @override
  String get unknownError => 'Something went wrong';

  @override
  String get confirmationTitle => 'Is this your car?';

  @override
  String get detailYear => 'Year';

  @override
  String get detailBattery => 'Battery';

  @override
  String get detailConnector => 'Connector';

  @override
  String batteryValue(int kwh) {
    return '$kwh kWh';
  }

  @override
  String get yesAddMyEv => 'Yes, add my EV';

  @override
  String get notMyCar => 'Not my car';

  @override
  String chargersHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chargers near you',
      one: '1 charger near you',
      zero: '0 chargers near you',
    );
    return '$_temp0';
  }

  @override
  String get chargersHeadingLoading => 'Chargers near you';

  @override
  String get chargingSummary => 'Charging 40% → 80%';

  @override
  String chargerDetails(int power, String connector, int free, int total) {
    return '$power kW · $connector · $free of $total free';
  }

  @override
  String get chargerTimeLabel => 'TIME';

  @override
  String get chargerTotalLabel => 'TOTAL';

  @override
  String minutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String totalValue(double amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.currency(
      locale: localeName,
      symbol: '£',
      decimalDigits: 2
    );
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString';
  }

  @override
  String get chargersEmptyTitle => 'No compatible chargers';

  @override
  String get chargersEmptyBody => 'We could not find any chargers that fit your car.';

  @override
  String get goBack => 'Go back';

  @override
  String get chargersFailureTitle => 'Could not load chargers';
}
