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
/// import 'generated/app_localizations.dart';
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
  /// **'Interactive Physics Simulator'**
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

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @newtonFirstLaw.
  ///
  /// In en, this message translates to:
  /// **'First Law'**
  String get newtonFirstLaw;

  /// No description provided for @newtonFirstLawDesc.
  ///
  /// In en, this message translates to:
  /// **'An object at rest stays at rest, and an object in motion stays in motion unless acted upon by an external force.'**
  String get newtonFirstLawDesc;

  /// No description provided for @newtonSecondLaw.
  ///
  /// In en, this message translates to:
  /// **'Second Law'**
  String get newtonSecondLaw;

  /// No description provided for @newtonSecondLawDesc.
  ///
  /// In en, this message translates to:
  /// **'The acceleration of an object depends on the mass of the object and the amount of force applied.'**
  String get newtonSecondLawDesc;

  /// No description provided for @newtonThirdLaw.
  ///
  /// In en, this message translates to:
  /// **'Third Law'**
  String get newtonThirdLaw;

  /// No description provided for @newtonThirdLawDesc.
  ///
  /// In en, this message translates to:
  /// **'For every action, there is an equal and opposite reaction.'**
  String get newtonThirdLawDesc;

  /// No description provided for @mass.
  ///
  /// In en, this message translates to:
  /// **'Mass'**
  String get mass;

  /// No description provided for @velocity.
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get velocity;

  /// No description provided for @acceleration.
  ///
  /// In en, this message translates to:
  /// **'Acceleration'**
  String get acceleration;

  /// No description provided for @force.
  ///
  /// In en, this message translates to:
  /// **'Force'**
  String get force;

  /// No description provided for @gravity.
  ///
  /// In en, this message translates to:
  /// **'GRAVITY'**
  String get gravity;

  /// No description provided for @friction.
  ///
  /// In en, this message translates to:
  /// **'Friction'**
  String get friction;

  /// No description provided for @applyForce.
  ///
  /// In en, this message translates to:
  /// **'Apply Force'**
  String get applyForce;

  /// No description provided for @showVectors.
  ///
  /// In en, this message translates to:
  /// **'Show Vectors'**
  String get showVectors;

  /// No description provided for @showTrail.
  ///
  /// In en, this message translates to:
  /// **'Show Trail'**
  String get showTrail;

  /// No description provided for @launchObject.
  ///
  /// In en, this message translates to:
  /// **'Launch Object'**
  String get launchObject;

  /// No description provided for @newtonLabTitle.
  ///
  /// In en, this message translates to:
  /// **'NewtonLab'**
  String get newtonLabTitle;

  /// No description provided for @law1Title.
  ///
  /// In en, this message translates to:
  /// **'Law 1: Inertia'**
  String get law1Title;

  /// No description provided for @law1Tagline.
  ///
  /// In en, this message translates to:
  /// **'Explore Friction and Motion'**
  String get law1Tagline;

  /// No description provided for @law2Title.
  ///
  /// In en, this message translates to:
  /// **'Law 2: F = ma'**
  String get law2Title;

  /// No description provided for @law2Tagline.
  ///
  /// In en, this message translates to:
  /// **'Force, Mass, and Acceleration'**
  String get law2Tagline;

  /// No description provided for @law3Title.
  ///
  /// In en, this message translates to:
  /// **'Law 3: Action & Reaction'**
  String get law3Title;

  /// No description provided for @law3Tagline.
  ///
  /// In en, this message translates to:
  /// **'Collisions and Rocket Propulsion'**
  String get law3Tagline;

  /// No description provided for @law1ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Law 1: Inertia & Friction'**
  String get law1ScreenTitle;

  /// No description provided for @firstLawFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Newton\'s First Law'**
  String get firstLawFullTitle;

  /// No description provided for @firstLawFormula.
  ///
  /// In en, this message translates to:
  /// **'ΣF = 0 → a = 0'**
  String get firstLawFormula;

  /// No description provided for @surface.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surface;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @launch.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get launch;

  /// No description provided for @simulate.
  ///
  /// In en, this message translates to:
  /// **'Simulate'**
  String get simulate;

  /// No description provided for @law2ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Law 2: F = ma'**
  String get law2ScreenTitle;

  /// No description provided for @law3ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Law 3: Action & Reaction'**
  String get law3ScreenTitle;

  /// No description provided for @demo.
  ///
  /// In en, this message translates to:
  /// **'Demo:'**
  String get demo;

  /// No description provided for @elasticCollisions.
  ///
  /// In en, this message translates to:
  /// **'Elastic Collisions'**
  String get elasticCollisions;

  /// No description provided for @rocketPropulsion.
  ///
  /// In en, this message translates to:
  /// **'Rocket Propulsion'**
  String get rocketPropulsion;

  /// No description provided for @massA.
  ///
  /// In en, this message translates to:
  /// **'Mass A'**
  String get massA;

  /// No description provided for @massB.
  ///
  /// In en, this message translates to:
  /// **'Mass B'**
  String get massB;

  /// No description provided for @bounciness.
  ///
  /// In en, this message translates to:
  /// **'Bounciness (e)'**
  String get bounciness;

  /// No description provided for @newtonSecondLawFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Newton\'s Second Law'**
  String get newtonSecondLawFullTitle;

  /// No description provided for @newtonSecondLawFormula.
  ///
  /// In en, this message translates to:
  /// **'F = m × a'**
  String get newtonSecondLawFormula;

  /// No description provided for @appliedForce.
  ///
  /// In en, this message translates to:
  /// **'Applied Force'**
  String get appliedForce;

  /// No description provided for @newtonThirdLawFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Newton\'s Third Law'**
  String get newtonThirdLawFullTitle;

  /// No description provided for @collisions.
  ///
  /// In en, this message translates to:
  /// **'Collisions'**
  String get collisions;

  /// No description provided for @rocketDescription.
  ///
  /// In en, this message translates to:
  /// **'A rocket expels particles downward (Action), which pushes the rocket upward (Reaction).'**
  String get rocketDescription;

  /// No description provided for @exhaust.
  ///
  /// In en, this message translates to:
  /// **'Exhaust'**
  String get exhaust;

  /// No description provided for @thrust.
  ///
  /// In en, this message translates to:
  /// **'Thrust'**
  String get thrust;

  /// No description provided for @voltage.
  ///
  /// In en, this message translates to:
  /// **'VOLTAGE'**
  String get voltage;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get current;

  /// No description provided for @resistance.
  ///
  /// In en, this message translates to:
  /// **'RESISTANCE'**
  String get resistance;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'POWER'**
  String get power;

  /// No description provided for @resistor.
  ///
  /// In en, this message translates to:
  /// **'Resistor'**
  String get resistor;

  /// No description provided for @capacitor.
  ///
  /// In en, this message translates to:
  /// **'Capacitor'**
  String get capacitor;

  /// No description provided for @inductor.
  ///
  /// In en, this message translates to:
  /// **'Inductor'**
  String get inductor;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @bulb.
  ///
  /// In en, this message translates to:
  /// **'Light Bulb'**
  String get bulb;

  /// No description provided for @circuitSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get circuitSwitch;

  /// No description provided for @circuit.
  ///
  /// In en, this message translates to:
  /// **'Circuit'**
  String get circuit;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @parallel.
  ///
  /// In en, this message translates to:
  /// **'Parallel'**
  String get parallel;

  /// No description provided for @ohmsLaw.
  ///
  /// In en, this message translates to:
  /// **'Ohm\'s Law'**
  String get ohmsLaw;

  /// No description provided for @ohmsLawDesc.
  ///
  /// In en, this message translates to:
  /// **'V = IR'**
  String get ohmsLawDesc;

  /// No description provided for @simulator.
  ///
  /// In en, this message translates to:
  /// **'SIMULATOR'**
  String get simulator;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'LEARN'**
  String get learn;

  /// No description provided for @learnOhmsLaw.
  ///
  /// In en, this message translates to:
  /// **'Learn Ohm\'s Law'**
  String get learnOhmsLaw;

  /// No description provided for @fundamentalLaw.
  ///
  /// In en, this message translates to:
  /// **'The Fundamental Law'**
  String get fundamentalLaw;

  /// No description provided for @fundamentalLawDesc.
  ///
  /// In en, this message translates to:
  /// **'Ohm\'s Law states that the current through a conductor between two points is directly proportional to the voltage across the two points.'**
  String get fundamentalLawDesc;

  /// No description provided for @voltageV.
  ///
  /// In en, this message translates to:
  /// **'VOLTAGE (V)'**
  String get voltageV;

  /// No description provided for @voltageDesc.
  ///
  /// In en, this message translates to:
  /// **'The electrical potential difference between two points. Think of it as electrical pressure.'**
  String get voltageDesc;

  /// No description provided for @voltageUnit.
  ///
  /// In en, this message translates to:
  /// **'Measured in Volts (V)'**
  String get voltageUnit;

  /// No description provided for @currentI.
  ///
  /// In en, this message translates to:
  /// **'CURRENT (I)'**
  String get currentI;

  /// No description provided for @currentDesc.
  ///
  /// In en, this message translates to:
  /// **'The flow of electric charge. Think of it as the volume of water flowing through a pipe.'**
  String get currentDesc;

  /// No description provided for @currentUnit.
  ///
  /// In en, this message translates to:
  /// **'Measured in Amperes (A)'**
  String get currentUnit;

  /// No description provided for @resistanceR.
  ///
  /// In en, this message translates to:
  /// **'RESISTANCE (R)'**
  String get resistanceR;

  /// No description provided for @resistanceDesc.
  ///
  /// In en, this message translates to:
  /// **'A measure of the difficulty to pass an electric current through a conductor.'**
  String get resistanceDesc;

  /// No description provided for @resistanceUnit.
  ///
  /// In en, this message translates to:
  /// **'Measured in Ohms (Ω)'**
  String get resistanceUnit;

  /// No description provided for @theFormula.
  ///
  /// In en, this message translates to:
  /// **'The Formula'**
  String get theFormula;

  /// No description provided for @findVoltage.
  ///
  /// In en, this message translates to:
  /// **'To find Voltage'**
  String get findVoltage;

  /// No description provided for @findCurrent.
  ///
  /// In en, this message translates to:
  /// **'To find Current'**
  String get findCurrent;

  /// No description provided for @findResistance.
  ///
  /// In en, this message translates to:
  /// **'To find Resistance'**
  String get findResistance;

  /// No description provided for @powerDissipation.
  ///
  /// In en, this message translates to:
  /// **'POWER DISSIPATION'**
  String get powerDissipation;

  /// No description provided for @ohmsLawWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: High voltage detected!'**
  String get ohmsLawWarning;

  /// No description provided for @addComponent.
  ///
  /// In en, this message translates to:
  /// **'Add Component'**
  String get addComponent;

  /// No description provided for @removeComponent.
  ///
  /// In en, this message translates to:
  /// **'Remove Component'**
  String get removeComponent;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @physicsAtYourFingertips.
  ///
  /// In en, this message translates to:
  /// **'PHYSICS AT YOUR FINGERTIPS'**
  String get physicsAtYourFingertips;

  /// No description provided for @projectileTitle.
  ///
  /// In en, this message translates to:
  /// **'Physics\nShot'**
  String get projectileTitle;

  /// No description provided for @launchSimulator.
  ///
  /// In en, this message translates to:
  /// **'LAUNCH SIMULATOR'**
  String get launchSimulator;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get ready;

  /// No description provided for @drag.
  ///
  /// In en, this message translates to:
  /// **'DRAG'**
  String get drag;

  /// No description provided for @env.
  ///
  /// In en, this message translates to:
  /// **'ENV'**
  String get env;

  /// No description provided for @earth.
  ///
  /// In en, this message translates to:
  /// **'EARTH'**
  String get earth;

  /// No description provided for @eightProjectiles.
  ///
  /// In en, this message translates to:
  /// **'8 Projectiles'**
  String get eightProjectiles;

  /// No description provided for @fourPlanets.
  ///
  /// In en, this message translates to:
  /// **'4 Planets'**
  String get fourPlanets;

  /// No description provided for @airResistance.
  ///
  /// In en, this message translates to:
  /// **'Air Resistance'**
  String get airResistance;

  /// No description provided for @liveGraphs.
  ///
  /// In en, this message translates to:
  /// **'Live Graphs'**
  String get liveGraphs;

  /// No description provided for @slowMotion.
  ///
  /// In en, this message translates to:
  /// **'Slow Motion'**
  String get slowMotion;

  /// No description provided for @challengeMode.
  ///
  /// In en, this message translates to:
  /// **'Challenge Mode'**
  String get challengeMode;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pSlowMo.
  ///
  /// In en, this message translates to:
  /// **'Slow Mo'**
  String get pSlowMo;

  /// No description provided for @pNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get pNormal;

  /// No description provided for @pLaunch.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get pLaunch;

  /// No description provided for @pPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pPause;

  /// No description provided for @pResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get pResume;

  /// No description provided for @pReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get pReset;

  /// No description provided for @pAngle.
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get pAngle;

  /// No description provided for @pSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get pSpeed;

  /// No description provided for @pHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get pHeight;

  /// No description provided for @pGravity.
  ///
  /// In en, this message translates to:
  /// **'Gravity'**
  String get pGravity;

  /// No description provided for @pCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get pCustom;

  /// No description provided for @pProjectile.
  ///
  /// In en, this message translates to:
  /// **'Projectile'**
  String get pProjectile;

  /// No description provided for @pMass.
  ///
  /// In en, this message translates to:
  /// **'Mass'**
  String get pMass;

  /// No description provided for @pRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get pRadius;

  /// No description provided for @pDragCoeff.
  ///
  /// In en, this message translates to:
  /// **'Drag Coeff'**
  String get pDragCoeff;

  /// No description provided for @pTargetDistance.
  ///
  /// In en, this message translates to:
  /// **'TARGET DISTANCE'**
  String get pTargetDistance;

  /// No description provided for @pCurrentScore.
  ///
  /// In en, this message translates to:
  /// **'CURRENT SCORE'**
  String get pCurrentScore;

  /// No description provided for @pBullseye.
  ///
  /// In en, this message translates to:
  /// **'BULLSEYE! +100 POINTS'**
  String get pBullseye;

  /// No description provided for @pAirResistance.
  ///
  /// In en, this message translates to:
  /// **'Air Resistance (Drag)'**
  String get pAirResistance;

  /// No description provided for @pChallengeMode.
  ///
  /// In en, this message translates to:
  /// **'Challenge Mode'**
  String get pChallengeMode;

  /// No description provided for @pShowForces.
  ///
  /// In en, this message translates to:
  /// **'Show Forces'**
  String get pShowForces;

  /// No description provided for @pShowVelocity.
  ///
  /// In en, this message translates to:
  /// **'Show Velocity'**
  String get pShowVelocity;

  /// No description provided for @pUsingDrag.
  ///
  /// In en, this message translates to:
  /// **'Using realistic drag for:'**
  String get pUsingDrag;

  /// No description provided for @pRange.
  ///
  /// In en, this message translates to:
  /// **'RANGE'**
  String get pRange;

  /// No description provided for @pMaxHeight.
  ///
  /// In en, this message translates to:
  /// **'Max Height'**
  String get pMaxHeight;

  /// No description provided for @pTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get pTime;

  /// No description provided for @pMath.
  ///
  /// In en, this message translates to:
  /// **'MATH'**
  String get pMath;

  /// No description provided for @pViewMath.
  ///
  /// In en, this message translates to:
  /// **'View Math'**
  String get pViewMath;

  /// No description provided for @pProFeature.
  ///
  /// In en, this message translates to:
  /// **'Pro Feature'**
  String get pProFeature;

  /// No description provided for @pAltitudeVsDist.
  ///
  /// In en, this message translates to:
  /// **'ALTITUDE vs DIST'**
  String get pAltitudeVsDist;

  /// No description provided for @pVelocityVsTime.
  ///
  /// In en, this message translates to:
  /// **'VELOCITY vs TIME'**
  String get pVelocityVsTime;

  /// No description provided for @pAltitudeVsDistance.
  ///
  /// In en, this message translates to:
  /// **'ALTITUDE vs DISTANCE'**
  String get pAltitudeVsDistance;

  /// No description provided for @pDistanceM.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE (m)'**
  String get pDistanceM;

  /// No description provided for @pTimeS.
  ///
  /// In en, this message translates to:
  /// **'TIME (s)'**
  String get pTimeS;

  /// No description provided for @pHeightM.
  ///
  /// In en, this message translates to:
  /// **'HEIGHT (m)'**
  String get pHeightM;

  /// No description provided for @pSpeedMs.
  ///
  /// In en, this message translates to:
  /// **'SPEED (m/s)'**
  String get pSpeedMs;

  /// No description provided for @pFormulaGuide.
  ///
  /// In en, this message translates to:
  /// **'Formula Guide'**
  String get pFormulaGuide;

  /// No description provided for @pLaunchSimulation.
  ///
  /// In en, this message translates to:
  /// **'Launch a simulation to generate trajectory graphs.'**
  String get pLaunchSimulation;

  /// No description provided for @pKinematicEquations.
  ///
  /// In en, this message translates to:
  /// **'Kinematic Equations'**
  String get pKinematicEquations;

  /// No description provided for @pKeyResults.
  ///
  /// In en, this message translates to:
  /// **'Key Results'**
  String get pKeyResults;

  /// No description provided for @pHorizontalPosition.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Position'**
  String get pHorizontalPosition;

  /// No description provided for @pVerticalPosition.
  ///
  /// In en, this message translates to:
  /// **'Vertical Position'**
  String get pVerticalPosition;

  /// No description provided for @pHorizontalVelocity.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Velocity'**
  String get pHorizontalVelocity;

  /// No description provided for @pVerticalVelocity.
  ///
  /// In en, this message translates to:
  /// **'Vertical Velocity'**
  String get pVerticalVelocity;

  /// No description provided for @pHangTime.
  ///
  /// In en, this message translates to:
  /// **'Hang Time'**
  String get pHangTime;

  /// No description provided for @pRangeNoAir.
  ///
  /// In en, this message translates to:
  /// **'Range (no air resistance)'**
  String get pRangeNoAir;

  /// No description provided for @pSpeedAtAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Speed at Any Time'**
  String get pSpeedAtAnyTime;

  /// No description provided for @pDragForce.
  ///
  /// In en, this message translates to:
  /// **'Drag Force'**
  String get pDragForce;

  /// No description provided for @pAirResistanceDrag.
  ///
  /// In en, this message translates to:
  /// **'Air Resistance (Drag)'**
  String get pAirResistanceDrag;

  /// No description provided for @pConstants.
  ///
  /// In en, this message translates to:
  /// **'⚙️ CONSTANTS'**
  String get pConstants;

  /// No description provided for @pRangeNoAirRes.
  ///
  /// In en, this message translates to:
  /// **'Range (no air resistance)'**
  String get pRangeNoAirRes;

  /// No description provided for @pNetAcceleration.
  ///
  /// In en, this message translates to:
  /// **'Net Acceleration (with drag)'**
  String get pNetAcceleration;

  /// No description provided for @pHorizDistAtTime.
  ///
  /// In en, this message translates to:
  /// **'Horizontal distance at time t. Constant velocity — no forces act horizontally (without air resistance).'**
  String get pHorizDistAtTime;

  /// No description provided for @pHeightAtTime.
  ///
  /// In en, this message translates to:
  /// **'Height at time t. The −½g·t² term is the effect of gravity pulling the projectile down.'**
  String get pHeightAtTime;

  /// No description provided for @pConstantThroughout.
  ///
  /// In en, this message translates to:
  /// **'Constant throughout flight (no horizontal forces without drag).'**
  String get pConstantThroughout;

  /// No description provided for @pDecreasesLinearly.
  ///
  /// In en, this message translates to:
  /// **'Decreases linearly due to gravity. Zero at peak height.'**
  String get pDecreasesLinearly;

  /// No description provided for @pTotalFlightTime.
  ///
  /// In en, this message translates to:
  /// **'Total flight time from launch to landing. Derived from setting y(t) = 0.'**
  String get pTotalFlightTime;

  /// No description provided for @pMaxHorizDist.
  ///
  /// In en, this message translates to:
  /// **'Maximum horizontal distance. For h₀ = 0 and θ = 45°: R = v₀² / g (optimal range).'**
  String get pMaxHorizDist;

  /// No description provided for @pPeakHeight.
  ///
  /// In en, this message translates to:
  /// **'Peak height above ground. Reached when vᵧ = 0, i.e., at t = v₀·sin(θ) / g.'**
  String get pPeakHeight;

  /// No description provided for @pPythagoras.
  ///
  /// In en, this message translates to:
  /// **'Pythagoras on the velocity components. Minimum at peak (= vₓ), maximum at launch.'**
  String get pPythagoras;

  /// No description provided for @pDragForceDesc.
  ///
  /// In en, this message translates to:
  /// **'ρ = air density (1.225 kg/m³), Cₐ = drag coefficient, A = cross-sectional area, v = speed. Opposes velocity.'**
  String get pDragForceDesc;

  /// No description provided for @pEulerIntegration.
  ///
  /// In en, this message translates to:
  /// **'We use Euler Integration to solve the motion numerically'**
  String get pEulerIntegration;

  /// No description provided for @pGEarth.
  ///
  /// In en, this message translates to:
  /// **'g (Earth)'**
  String get pGEarth;

  /// No description provided for @pGMoon.
  ///
  /// In en, this message translates to:
  /// **'g (Moon)'**
  String get pGMoon;

  /// No description provided for @pGMars.
  ///
  /// In en, this message translates to:
  /// **'g (Mars)'**
  String get pGMars;

  /// No description provided for @pGJupiter.
  ///
  /// In en, this message translates to:
  /// **'g (Jupiter)'**
  String get pGJupiter;

  /// No description provided for @pAirDensity.
  ///
  /// In en, this message translates to:
  /// **'ρ (air, sea level)'**
  String get pAirDensity;

  /// No description provided for @pDerivationModule.
  ///
  /// In en, this message translates to:
  /// **'Derivation Module'**
  String get pDerivationModule;

  /// No description provided for @pStepByStepDerivation.
  ///
  /// In en, this message translates to:
  /// **'Step-by-Step Derivation'**
  String get pStepByStepDerivation;

  /// No description provided for @pIdealCase.
  ///
  /// In en, this message translates to:
  /// **'Ideal Case'**
  String get pIdealCase;

  /// No description provided for @pAirResistanceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Air Resistance Breakdown'**
  String get pAirResistanceBreakdown;

  /// No description provided for @pDoesMassMatter.
  ///
  /// In en, this message translates to:
  /// **'Does Mass Matter?'**
  String get pDoesMassMatter;

  /// No description provided for @pHigherMass.
  ///
  /// In en, this message translates to:
  /// **'Higher Mass: The air has a harder time slowing the object down → Further range.'**
  String get pHigherMass;

  /// No description provided for @pLowerMass.
  ///
  /// In en, this message translates to:
  /// **'Lower Mass: The air easily decelerates the object → Shorter range.'**
  String get pLowerMass;

  /// No description provided for @pHowItsCalculated.
  ///
  /// In en, this message translates to:
  /// **'How it\'s Calculated'**
  String get pHowItsCalculated;

  /// No description provided for @pAtEachTimeStep.
  ///
  /// In en, this message translates to:
  /// **'At each time step (dt):'**
  String get pAtEachTimeStep;

  /// No description provided for @pCalculateDragForce.
  ///
  /// In en, this message translates to:
  /// **'Calculate Drag Force: F_d = ½ ρ v² C_d A'**
  String get pCalculateDragForce;

  /// No description provided for @pUpdateAcceleration.
  ///
  /// In en, this message translates to:
  /// **'Update Acceleration: a = F_net / m (Note how mass m is the divisor!)'**
  String get pUpdateAcceleration;

  /// No description provided for @pUpdateVelocity.
  ///
  /// In en, this message translates to:
  /// **'Update Velocity and Position.'**
  String get pUpdateVelocity;

  /// No description provided for @pBowlingBall.
  ///
  /// In en, this message translates to:
  /// **'This is why a bowling ball travels much further than a golf ball in the air, even if they start with the same velocity!'**
  String get pBowlingBall;

  /// No description provided for @pGalileoPrinciple.
  ///
  /// In en, this message translates to:
  /// **'The Galileo Principle (Mass Independence)'**
  String get pGalileoPrinciple;

  /// No description provided for @pInVacuum.
  ///
  /// In en, this message translates to:
  /// **'In a vacuum (Air Resistance OFF), mass does not affect the trajectory.'**
  String get pInVacuum;

  /// No description provided for @pVelocityComponents.
  ///
  /// In en, this message translates to:
  /// **'1. Velocity Components'**
  String get pVelocityComponents;

  /// No description provided for @pBreakInitialVelocity.
  ///
  /// In en, this message translates to:
  /// **'Break initial velocity (v_0 = {v0} m/s) into Horizontal (v_x) and Vertical (v_y) components using trigonometry:'**
  String pBreakInitialVelocity(Object v0);

  /// No description provided for @pTimeToPeakHeight.
  ///
  /// In en, this message translates to:
  /// **'2. Time to Peak Height'**
  String get pTimeToPeakHeight;

  /// No description provided for @pAtThePeak.
  ///
  /// In en, this message translates to:
  /// **'At the peak, vertical velocity v_y is 0. Solving v_y = v_y0 - g t:'**
  String get pAtThePeak;

  /// No description provided for @pMaximumHeight.
  ///
  /// In en, this message translates to:
  /// **'3. Maximum Height'**
  String get pMaximumHeight;

  /// No description provided for @pUsingDisplacement.
  ///
  /// In en, this message translates to:
  /// **'Using the displacement formula y = y0 + v_y0 t - ½ g t²:'**
  String get pUsingDisplacement;

  /// No description provided for @pTotalHangTime.
  ///
  /// In en, this message translates to:
  /// **'4. Total Hang Time'**
  String get pTotalHangTime;

  /// No description provided for @pSolveQuadratic.
  ///
  /// In en, this message translates to:
  /// **'Solve the quadratic equation for when height y = 0:'**
  String get pSolveQuadratic;

  /// No description provided for @pUsingQuadraticFormula.
  ///
  /// In en, this message translates to:
  /// **'Using the quadratic formula:'**
  String get pUsingQuadraticFormula;

  /// No description provided for @pHorizontalRange.
  ///
  /// In en, this message translates to:
  /// **'5. Horizontal Range'**
  String get pHorizontalRange;

  /// No description provided for @pInIdealCase.
  ///
  /// In en, this message translates to:
  /// **'In the ideal case, horizontal velocity v_x is constant.'**
  String get pInIdealCase;

  /// No description provided for @pYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get pYes;

  /// No description provided for @pInTheRealWorld.
  ///
  /// In en, this message translates to:
  /// **'In the real world'**
  String get pInTheRealWorld;

  /// No description provided for @pFurtherRange.
  ///
  /// In en, this message translates to:
  /// **'The air has a harder time slowing the object down. Further range.'**
  String get pFurtherRange;

  /// No description provided for @pShorterRange.
  ///
  /// In en, this message translates to:
  /// **'The air easily decelerates the object. Shorter range.'**
  String get pShorterRange;

  /// No description provided for @pWeUseEuler.
  ///
  /// In en, this message translates to:
  /// **'We use Euler Integration to solve the motion numerically:'**
  String get pWeUseEuler;

  /// No description provided for @simulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get simulation;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @trajectory.
  ///
  /// In en, this message translates to:
  /// **'Trajectory'**
  String get trajectory;

  /// No description provided for @initialVelocity.
  ///
  /// In en, this message translates to:
  /// **'Initial Velocity'**
  String get initialVelocity;

  /// No description provided for @launchAngle.
  ///
  /// In en, this message translates to:
  /// **'Launch Angle'**
  String get launchAngle;

  /// No description provided for @launchSpeed.
  ///
  /// In en, this message translates to:
  /// **'Launch Speed'**
  String get launchSpeed;

  /// No description provided for @maximumHeight.
  ///
  /// In en, this message translates to:
  /// **'Maximum Height'**
  String get maximumHeight;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @fire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @amplitude.
  ///
  /// In en, this message translates to:
  /// **'Amplitude'**
  String get amplitude;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @wavelength.
  ///
  /// In en, this message translates to:
  /// **'Wavelength'**
  String get wavelength;

  /// No description provided for @phase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get phase;

  /// No description provided for @peakVoltage.
  ///
  /// In en, this message translates to:
  /// **'Peak Voltage'**
  String get peakVoltage;

  /// No description provided for @rmsVoltage.
  ///
  /// In en, this message translates to:
  /// **'RMS Voltage'**
  String get rmsVoltage;

  /// No description provided for @oscilloscope.
  ///
  /// In en, this message translates to:
  /// **'Oscilloscope'**
  String get oscilloscope;

  /// No description provided for @waveform.
  ///
  /// In en, this message translates to:
  /// **'Waveform'**
  String get waveform;

  /// No description provided for @sineWave.
  ///
  /// In en, this message translates to:
  /// **'Sine Wave'**
  String get sineWave;

  /// No description provided for @squareWave.
  ///
  /// In en, this message translates to:
  /// **'Square Wave'**
  String get squareWave;

  /// No description provided for @sawtoothWave.
  ///
  /// In en, this message translates to:
  /// **'Sawtooth Wave'**
  String get sawtoothWave;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @waveSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wave Speed'**
  String get waveSpeed;

  /// No description provided for @transverse.
  ///
  /// In en, this message translates to:
  /// **'Transverse'**
  String get transverse;

  /// No description provided for @longitudinal.
  ///
  /// In en, this message translates to:
  /// **'Longitudinal'**
  String get longitudinal;

  /// No description provided for @reflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get reflection;

  /// No description provided for @refraction.
  ///
  /// In en, this message translates to:
  /// **'Refraction'**
  String get refraction;

  /// No description provided for @diffraction.
  ///
  /// In en, this message translates to:
  /// **'Diffraction'**
  String get diffraction;

  /// No description provided for @interference.
  ///
  /// In en, this message translates to:
  /// **'Interference'**
  String get interference;

  /// No description provided for @standingWave.
  ///
  /// In en, this message translates to:
  /// **'Standing Wave'**
  String get standingWave;

  /// No description provided for @node.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get node;

  /// No description provided for @antinode.
  ///
  /// In en, this message translates to:
  /// **'Antinode'**
  String get antinode;

  /// No description provided for @damping.
  ///
  /// In en, this message translates to:
  /// **'Damping'**
  String get damping;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @heat.
  ///
  /// In en, this message translates to:
  /// **'Heat'**
  String get heat;

  /// No description provided for @thermalEnergy.
  ///
  /// In en, this message translates to:
  /// **'Thermal Energy'**
  String get thermalEnergy;

  /// No description provided for @entropy.
  ///
  /// In en, this message translates to:
  /// **'Entropy'**
  String get entropy;

  /// No description provided for @internalEnergy.
  ///
  /// In en, this message translates to:
  /// **'Internal Energy'**
  String get internalEnergy;

  /// No description provided for @specificHeat.
  ///
  /// In en, this message translates to:
  /// **'Specific Heat'**
  String get specificHeat;

  /// No description provided for @latentHeat.
  ///
  /// In en, this message translates to:
  /// **'Latent Heat'**
  String get latentHeat;

  /// No description provided for @conduction.
  ///
  /// In en, this message translates to:
  /// **'Conduction'**
  String get conduction;

  /// No description provided for @convection.
  ///
  /// In en, this message translates to:
  /// **'Convection'**
  String get convection;

  /// No description provided for @radiation.
  ///
  /// In en, this message translates to:
  /// **'Radiation'**
  String get radiation;

  /// No description provided for @insulator.
  ///
  /// In en, this message translates to:
  /// **'Insulator'**
  String get insulator;

  /// No description provided for @conductor.
  ///
  /// In en, this message translates to:
  /// **'Conductor'**
  String get conductor;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// No description provided for @kelvin.
  ///
  /// In en, this message translates to:
  /// **'Kelvin'**
  String get kelvin;

  /// No description provided for @firstLaw.
  ///
  /// In en, this message translates to:
  /// **'First Law'**
  String get firstLaw;

  /// No description provided for @secondLaw.
  ///
  /// In en, this message translates to:
  /// **'Second Law'**
  String get secondLaw;

  /// No description provided for @absoluteZero.
  ///
  /// In en, this message translates to:
  /// **'Absolute Zero'**
  String get absoluteZero;

  /// No description provided for @atom.
  ///
  /// In en, this message translates to:
  /// **'Atom'**
  String get atom;

  /// No description provided for @electron.
  ///
  /// In en, this message translates to:
  /// **'Electron'**
  String get electron;

  /// No description provided for @proton.
  ///
  /// In en, this message translates to:
  /// **'Proton'**
  String get proton;

  /// No description provided for @neutron.
  ///
  /// In en, this message translates to:
  /// **'Neutron'**
  String get neutron;

  /// No description provided for @nucleus.
  ///
  /// In en, this message translates to:
  /// **'Nucleus'**
  String get nucleus;

  /// No description provided for @orbital.
  ///
  /// In en, this message translates to:
  /// **'Orbital'**
  String get orbital;

  /// No description provided for @shell.
  ///
  /// In en, this message translates to:
  /// **'Shell'**
  String get shell;

  /// No description provided for @subshell.
  ///
  /// In en, this message translates to:
  /// **'Subshell'**
  String get subshell;

  /// No description provided for @bohrModel.
  ///
  /// In en, this message translates to:
  /// **'Bohr Model'**
  String get bohrModel;

  /// No description provided for @electronConfig.
  ///
  /// In en, this message translates to:
  /// **'Electron Configuration'**
  String get electronConfig;

  /// No description provided for @sOrbital.
  ///
  /// In en, this message translates to:
  /// **'s Orbital'**
  String get sOrbital;

  /// No description provided for @pOrbital.
  ///
  /// In en, this message translates to:
  /// **'p Orbital'**
  String get pOrbital;

  /// No description provided for @dOrbital.
  ///
  /// In en, this message translates to:
  /// **'d Orbital'**
  String get dOrbital;

  /// No description provided for @fOrbital.
  ///
  /// In en, this message translates to:
  /// **'f Orbital'**
  String get fOrbital;

  /// No description provided for @periodicTable.
  ///
  /// In en, this message translates to:
  /// **'Periodic Table'**
  String get periodicTable;

  /// No description provided for @element.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get element;

  /// No description provided for @atomicNumber.
  ///
  /// In en, this message translates to:
  /// **'Atomic Number'**
  String get atomicNumber;

  /// No description provided for @atomicMass.
  ///
  /// In en, this message translates to:
  /// **'Atomic Mass'**
  String get atomicMass;

  /// No description provided for @valenceElectron.
  ///
  /// In en, this message translates to:
  /// **'Valence Electron'**
  String get valenceElectron;

  /// No description provided for @molecule.
  ///
  /// In en, this message translates to:
  /// **'Molecule'**
  String get molecule;

  /// No description provided for @bond.
  ///
  /// In en, this message translates to:
  /// **'Bond'**
  String get bond;

  /// No description provided for @ionicBond.
  ///
  /// In en, this message translates to:
  /// **'Ionic Bond'**
  String get ionicBond;

  /// No description provided for @covalentBond.
  ///
  /// In en, this message translates to:
  /// **'Covalent Bond'**
  String get covalentBond;

  /// No description provided for @vsepr.
  ///
  /// In en, this message translates to:
  /// **'VSEPR'**
  String get vsepr;

  /// No description provided for @molecularGeometry.
  ///
  /// In en, this message translates to:
  /// **'Molecular Geometry'**
  String get molecularGeometry;

  /// No description provided for @linear.
  ///
  /// In en, this message translates to:
  /// **'Linear'**
  String get linear;

  /// No description provided for @trigonalPlanar.
  ///
  /// In en, this message translates to:
  /// **'Trigonal Planar'**
  String get trigonalPlanar;

  /// No description provided for @tetrahedral.
  ///
  /// In en, this message translates to:
  /// **'Tetrahedral'**
  String get tetrahedral;

  /// No description provided for @octahedral.
  ///
  /// In en, this message translates to:
  /// **'Octahedral'**
  String get octahedral;

  /// No description provided for @acid.
  ///
  /// In en, this message translates to:
  /// **'Acid'**
  String get acid;

  /// No description provided for @base.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get base;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @ph.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get ph;

  /// No description provided for @indicator.
  ///
  /// In en, this message translates to:
  /// **'Indicator'**
  String get indicator;

  /// No description provided for @substance.
  ///
  /// In en, this message translates to:
  /// **'Substance'**
  String get substance;

  /// No description provided for @litmus.
  ///
  /// In en, this message translates to:
  /// **'Litmus'**
  String get litmus;

  /// No description provided for @phenolphthalein.
  ///
  /// In en, this message translates to:
  /// **'Phenolphthalein'**
  String get phenolphthalein;

  /// No description provided for @methylOrange.
  ///
  /// In en, this message translates to:
  /// **'Methyl Orange'**
  String get methylOrange;

  /// No description provided for @universalIndicator.
  ///
  /// In en, this message translates to:
  /// **'Universal Indicator'**
  String get universalIndicator;

  /// No description provided for @titration.
  ///
  /// In en, this message translates to:
  /// **'Titration'**
  String get titration;

  /// No description provided for @equivalencePoint.
  ///
  /// In en, this message translates to:
  /// **'Equivalence Point'**
  String get equivalencePoint;

  /// No description provided for @endpoint.
  ///
  /// In en, this message translates to:
  /// **'Endpoint'**
  String get endpoint;

  /// No description provided for @buffer.
  ///
  /// In en, this message translates to:
  /// **'Buffer'**
  String get buffer;

  /// No description provided for @strongAcid.
  ///
  /// In en, this message translates to:
  /// **'Strong Acid'**
  String get strongAcid;

  /// No description provided for @weakAcid.
  ///
  /// In en, this message translates to:
  /// **'Weak Acid'**
  String get weakAcid;

  /// No description provided for @strongBase.
  ///
  /// In en, this message translates to:
  /// **'Strong Base'**
  String get strongBase;

  /// No description provided for @weakBase.
  ///
  /// In en, this message translates to:
  /// **'Weak Base'**
  String get weakBase;

  /// No description provided for @dilute.
  ///
  /// In en, this message translates to:
  /// **'Dilute'**
  String get dilute;

  /// No description provided for @concentrate.
  ///
  /// In en, this message translates to:
  /// **'Concentrate'**
  String get concentrate;

  /// No description provided for @addSolution.
  ///
  /// In en, this message translates to:
  /// **'Add Solution'**
  String get addSolution;

  /// No description provided for @analyzePH.
  ///
  /// In en, this message translates to:
  /// **'Analyze pH'**
  String get analyzePH;

  /// No description provided for @anode.
  ///
  /// In en, this message translates to:
  /// **'Anode'**
  String get anode;

  /// No description provided for @cathode.
  ///
  /// In en, this message translates to:
  /// **'Cathode'**
  String get cathode;

  /// No description provided for @electrolyte.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte'**
  String get electrolyte;

  /// No description provided for @electrode.
  ///
  /// In en, this message translates to:
  /// **'Electrode'**
  String get electrode;

  /// No description provided for @ion.
  ///
  /// In en, this message translates to:
  /// **'Ion'**
  String get ion;

  /// No description provided for @oxidation.
  ///
  /// In en, this message translates to:
  /// **'Oxidation'**
  String get oxidation;

  /// No description provided for @reduction.
  ///
  /// In en, this message translates to:
  /// **'Reduction'**
  String get reduction;

  /// No description provided for @oxidationNumber.
  ///
  /// In en, this message translates to:
  /// **'Oxidation Number'**
  String get oxidationNumber;

  /// No description provided for @halfReaction.
  ///
  /// In en, this message translates to:
  /// **'Half Reaction'**
  String get halfReaction;

  /// No description provided for @fullReaction.
  ///
  /// In en, this message translates to:
  /// **'Full Reaction'**
  String get fullReaction;

  /// No description provided for @galvanicCell.
  ///
  /// In en, this message translates to:
  /// **'Galvanic Cell'**
  String get galvanicCell;

  /// No description provided for @electrolyticCell.
  ///
  /// In en, this message translates to:
  /// **'Electrolytic Cell'**
  String get electrolyticCell;

  /// No description provided for @standardPotential.
  ///
  /// In en, this message translates to:
  /// **'Standard Potential'**
  String get standardPotential;

  /// No description provided for @cellPotential.
  ///
  /// In en, this message translates to:
  /// **'Cell Potential'**
  String get cellPotential;

  /// No description provided for @faraday.
  ///
  /// In en, this message translates to:
  /// **'Faraday\'s Law'**
  String get faraday;

  /// No description provided for @electroplating.
  ///
  /// In en, this message translates to:
  /// **'Electroplating'**
  String get electroplating;

  /// No description provided for @electrolysis.
  ///
  /// In en, this message translates to:
  /// **'Electrolysis'**
  String get electrolysis;

  /// No description provided for @deposition.
  ///
  /// In en, this message translates to:
  /// **'Deposition'**
  String get deposition;

  /// No description provided for @dissolution.
  ///
  /// In en, this message translates to:
  /// **'Dissolution'**
  String get dissolution;

  /// No description provided for @batteryLife.
  ///
  /// In en, this message translates to:
  /// **'Battery Life'**
  String get batteryLife;

  /// No description provided for @fuelCell.
  ///
  /// In en, this message translates to:
  /// **'Fuel Cell'**
  String get fuelCell;
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
