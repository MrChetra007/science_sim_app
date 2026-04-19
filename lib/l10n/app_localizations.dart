import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Science Lab'**
  String get appTitle;

  /// No description provided for @virtualExperimentSuite.
  ///
  /// In en, this message translates to:
  /// **'Virtual Experiment Suite'**
  String get virtualExperimentSuite;

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'PHYSICS'**
  String get physics;

  /// No description provided for @physicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mechanics, Waves & Electricity'**
  String get physicsSubtitle;

  /// No description provided for @chemistry.
  ///
  /// In en, this message translates to:
  /// **'CHEMISTRY'**
  String get chemistry;

  /// No description provided for @chemistrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Acids, Bases & Reactions'**
  String get chemistrySubtitle;

  /// No description provided for @newtonLab.
  ///
  /// In en, this message translates to:
  /// **'NEWTON'**
  String get newtonLab;

  /// No description provided for @newtonLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Laws of Motion'**
  String get newtonLabSubtitle;

  /// No description provided for @ohmLab.
  ///
  /// In en, this message translates to:
  /// **'OHM'**
  String get ohmLab;

  /// No description provided for @ohmLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get ohmLabSubtitle;

  /// No description provided for @projectileLab.
  ///
  /// In en, this message translates to:
  /// **'PROJECTILE'**
  String get projectileLab;

  /// No description provided for @projectileLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kinematics'**
  String get projectileLabSubtitle;

  /// No description provided for @acLab.
  ///
  /// In en, this message translates to:
  /// **'AC LAB'**
  String get acLab;

  /// No description provided for @acLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alternating Current'**
  String get acLabSubtitle;

  /// No description provided for @waveLab.
  ///
  /// In en, this message translates to:
  /// **'WAVE LAB'**
  String get waveLab;

  /// No description provided for @waveLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wave Mechanics'**
  String get waveLabSubtitle;

  /// No description provided for @thermoLab.
  ///
  /// In en, this message translates to:
  /// **'THERMO'**
  String get thermoLab;

  /// No description provided for @thermoLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thermodynamics'**
  String get thermoLabSubtitle;

  /// No description provided for @atomicMolecular.
  ///
  /// In en, this message translates to:
  /// **'ATOMIC & MOLECULAR'**
  String get atomicMolecular;

  /// No description provided for @atomicMolecularSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Atoms & Molecules'**
  String get atomicMolecularSubtitle;

  /// No description provided for @phLab.
  ///
  /// In en, this message translates to:
  /// **'pH LAB'**
  String get phLab;

  /// No description provided for @phLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Acids & Bases'**
  String get phLabSubtitle;

  /// No description provided for @electrochem.
  ///
  /// In en, this message translates to:
  /// **'ELECTROCHEM'**
  String get electrochem;

  /// No description provided for @electrochemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Batteries & Electrolysis'**
  String get electrochemSubtitle;

  /// No description provided for @selectModuleToBegin.
  ///
  /// In en, this message translates to:
  /// **'Select a module to begin simulation'**
  String get selectModuleToBegin;

  /// No description provided for @helpTutorials.
  ///
  /// In en, this message translates to:
  /// **'Help & Tutorials'**
  String get helpTutorials;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @replayWalkthrough.
  ///
  /// In en, this message translates to:
  /// **'Replay walkthrough tutorials for any lab:'**
  String get replayWalkthrough;

  /// No description provided for @physicsLabs.
  ///
  /// In en, this message translates to:
  /// **'PHYSICS LABS'**
  String get physicsLabs;

  /// No description provided for @chemistryLabs.
  ///
  /// In en, this message translates to:
  /// **'CHEMISTRY LABS'**
  String get chemistryLabs;

  /// No description provided for @newtonLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'NewtonLab - Laws of Motion'**
  String get newtonLabTutorial;

  /// No description provided for @ohmLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'OhmLab - Circuit Simulation'**
  String get ohmLabTutorial;

  /// No description provided for @projectileLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'Projectile Motion'**
  String get projectileLabTutorial;

  /// No description provided for @acLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'AC Lab - Electricity'**
  String get acLabTutorial;

  /// No description provided for @waveLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'Wave Lab'**
  String get waveLabTutorial;

  /// No description provided for @thermoLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'Thermo Lab - Thermodynamics'**
  String get thermoLabTutorial;

  /// No description provided for @phLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'pH Lab'**
  String get phLabTutorial;

  /// No description provided for @atomicMolecularTutorial.
  ///
  /// In en, this message translates to:
  /// **'Atomic & Molecular'**
  String get atomicMolecularTutorial;

  /// No description provided for @electrochemTutorial.
  ///
  /// In en, this message translates to:
  /// **'Electrochemistry'**
  String get electrochemTutorial;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @khmer.
  ///
  /// In en, this message translates to:
  /// **'Khmer'**
  String get khmer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
