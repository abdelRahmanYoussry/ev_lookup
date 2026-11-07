import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'EV Lookup'**
  String get appTitle;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your EV'**
  String get registrationTitle;

  /// No description provided for @registrationStep.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 OF 2'**
  String get registrationStep;

  /// No description provided for @registrationHeading.
  ///
  /// In en, this message translates to:
  /// **'What\'s your registration?'**
  String get registrationHeading;

  /// No description provided for @registrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We look up your car so charging shows only chargers that fit, with real time and cost.'**
  String get registrationSubtitle;

  /// No description provided for @registrationHelper.
  ///
  /// In en, this message translates to:
  /// **'Check the plate on the back of your car.'**
  String get registrationHelper;

  /// No description provided for @findMyEv.
  ///
  /// In en, this message translates to:
  /// **'Find my EV'**
  String get findMyEv;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @enterRegistration.
  ///
  /// In en, this message translates to:
  /// **'Enter your registration'**
  String get enterRegistration;

  /// No description provided for @vehicleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not found'**
  String get vehicleNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unknownError;

  /// No description provided for @confirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Is this your car?'**
  String get confirmationTitle;

  /// No description provided for @detailYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get detailYear;

  /// No description provided for @detailBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get detailBattery;

  /// No description provided for @detailConnector.
  ///
  /// In en, this message translates to:
  /// **'Connector'**
  String get detailConnector;

  /// No description provided for @batteryValue.
  ///
  /// In en, this message translates to:
  /// **'{kwh} kWh'**
  String batteryValue(int kwh);

  /// No description provided for @yesAddMyEv.
  ///
  /// In en, this message translates to:
  /// **'Yes, add my EV'**
  String get yesAddMyEv;

  /// No description provided for @notMyCar.
  ///
  /// In en, this message translates to:
  /// **'Not my car'**
  String get notMyCar;

  /// No description provided for @chargersHeading.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 chargers near you} =1{1 charger near you} other{{count} chargers near you}}'**
  String chargersHeading(int count);

  /// No description provided for @chargersHeadingLoading.
  ///
  /// In en, this message translates to:
  /// **'Chargers near you'**
  String get chargersHeadingLoading;

  /// No description provided for @chargingSummary.
  ///
  /// In en, this message translates to:
  /// **'Charging 40% → 80%'**
  String get chargingSummary;

  /// No description provided for @chargerDetails.
  ///
  /// In en, this message translates to:
  /// **'{power} kW · {connector} · {free} of {total} free'**
  String chargerDetails(int power, String connector, int free, int total);

  /// No description provided for @chargerTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get chargerTimeLabel;

  /// No description provided for @chargerTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get chargerTotalLabel;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesValue(int minutes);

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'{amount}'**
  String totalValue(double amount);

  /// No description provided for @chargersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No compatible chargers'**
  String get chargersEmptyTitle;

  /// No description provided for @chargersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'We could not find any chargers that fit your car.'**
  String get chargersEmptyBody;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @chargersFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load chargers'**
  String get chargersFailureTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
