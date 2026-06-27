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

  /// No description provided for @waveTitle.
  ///
  /// In en, this message translates to:
  /// **'WAVE LAB'**
  String get waveTitle;

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

  /// No description provided for @thermoHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Thermo Lab'**
  String get thermoHomeTitle;

  /// No description provided for @thermoHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thermodynamics Simulation'**
  String get thermoHomeSubtitle;

  /// No description provided for @heatTransfer.
  ///
  /// In en, this message translates to:
  /// **'Heat Transfer'**
  String get heatTransfer;

  /// No description provided for @heatTransferSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Conduction, Convection, Radiation'**
  String get heatTransferSubtitle;

  /// No description provided for @gasLaws.
  ///
  /// In en, this message translates to:
  /// **'Gas Laws'**
  String get gasLaws;

  /// No description provided for @gasLawsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Boyle\'s, Charles\'s, Gay-Lussac\'s'**
  String get gasLawsSubtitle;

  /// No description provided for @gasLawsExplorer.
  ///
  /// In en, this message translates to:
  /// **'Gas Laws Explorer'**
  String get gasLawsExplorer;

  /// No description provided for @boylesLaw.
  ///
  /// In en, this message translates to:
  /// **'Boyle\'s Law'**
  String get boylesLaw;

  /// No description provided for @boylesLawDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure is inversely proportional to volume at constant temperature (PV = k).'**
  String get boylesLawDesc;

  /// No description provided for @charlesLaw.
  ///
  /// In en, this message translates to:
  /// **'Charles\'s Law'**
  String get charlesLaw;

  /// No description provided for @charlesLawDesc.
  ///
  /// In en, this message translates to:
  /// **'Volume is directly proportional to temperature at constant pressure (V/T = k).'**
  String get charlesLawDesc;

  /// No description provided for @gayLussacLaw.
  ///
  /// In en, this message translates to:
  /// **'Gay-Lussac\'s Law'**
  String get gayLussacLaw;

  /// No description provided for @gayLussacLawDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure is directly proportional to temperature at constant volume (P/T = k).'**
  String get gayLussacLawDesc;

  /// No description provided for @heatTransferLab.
  ///
  /// In en, this message translates to:
  /// **'Heat Transfer Lab'**
  String get heatTransferLab;

  /// No description provided for @carnotEngineSimulator.
  ///
  /// In en, this message translates to:
  /// **'Carnot Engine Simulator'**
  String get carnotEngineSimulator;

  /// No description provided for @phaseChangeSimulator.
  ///
  /// In en, this message translates to:
  /// **'Phase Change Simulator'**
  String get phaseChangeSimulator;

  /// No description provided for @lawsOfThermodynamics.
  ///
  /// In en, this message translates to:
  /// **'Laws of Thermodynamics'**
  String get lawsOfThermodynamics;

  /// No description provided for @entropyExplorer.
  ///
  /// In en, this message translates to:
  /// **'Entropy Explorer'**
  String get entropyExplorer;

  /// No description provided for @carnotEngine.
  ///
  /// In en, this message translates to:
  /// **'Carnot Engine'**
  String get carnotEngine;

  /// No description provided for @carnotEngineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Efficiency & Heat engines'**
  String get carnotEngineSubtitle;

  /// No description provided for @phaseChange.
  ///
  /// In en, this message translates to:
  /// **'Phase Change'**
  String get phaseChange;

  /// No description provided for @phaseChangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Heating curve & States of matter'**
  String get phaseChangeSubtitle;

  /// No description provided for @entropy.
  ///
  /// In en, this message translates to:
  /// **'Entropy'**
  String get entropy;

  /// No description provided for @entropySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disorder & 2nd Law'**
  String get entropySubtitle;

  /// No description provided for @lawsOfThermo.
  ///
  /// In en, this message translates to:
  /// **'Laws of Thermo'**
  String get lawsOfThermo;

  /// No description provided for @lawsOfThermoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'0th, 1st, 2nd, 3rd Laws'**
  String get lawsOfThermoSubtitle;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @proUnlockMessage.
  ///
  /// In en, this message translates to:
  /// **'PRO - Unlock for unlimited access'**
  String get proUnlockMessage;

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
  /// **'RESET'**
  String get reset;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
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
  /// **'Show Vectors (v/a)'**
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
  /// **'ΔU = Q - W'**
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
  /// **'Voltage'**
  String get voltage;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get current;

  /// No description provided for @resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistance (Ω)'**
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
  /// **'Resistor (R) opposes current flow and converts electrical energy to heat.'**
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

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'SCORE'**
  String get score;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get streak;

  /// No description provided for @targetFrequency.
  ///
  /// In en, this message translates to:
  /// **'TARGET FREQUENCY'**
  String get targetFrequency;

  /// No description provided for @targetHarmonic.
  ///
  /// In en, this message translates to:
  /// **'TARGET HARMONIC'**
  String get targetHarmonic;

  /// No description provided for @targetPhase.
  ///
  /// In en, this message translates to:
  /// **'TARGET PHASE'**
  String get targetPhase;

  /// No description provided for @matched.
  ///
  /// In en, this message translates to:
  /// **'MATCHED!'**
  String get matched;

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

  /// No description provided for @acElectricityLab.
  ///
  /// In en, this message translates to:
  /// **'AC ELECTRICITY LAB'**
  String get acElectricityLab;

  /// No description provided for @oscilloscopeMode.
  ///
  /// In en, this message translates to:
  /// **'Oscilloscope Mode'**
  String get oscilloscopeMode;

  /// No description provided for @transformerLab.
  ///
  /// In en, this message translates to:
  /// **'Transformer Lab'**
  String get transformerLab;

  /// No description provided for @rlcReactiveLab.
  ///
  /// In en, this message translates to:
  /// **'REACTIVE (RLC) LAB'**
  String get rlcReactiveLab;

  /// No description provided for @upgradeLab.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Lab'**
  String get upgradeLab;

  /// No description provided for @advancedOscilloscope.
  ///
  /// In en, this message translates to:
  /// **'ADVANCED OSCILLOSCOPE'**
  String get advancedOscilloscope;

  /// No description provided for @oscilloscopeGuide.
  ///
  /// In en, this message translates to:
  /// **'Oscilloscope Guide'**
  String get oscilloscopeGuide;

  /// No description provided for @voltsPerDiv.
  ///
  /// In en, this message translates to:
  /// **'Volts / Div'**
  String get voltsPerDiv;

  /// No description provided for @timePerDiv.
  ///
  /// In en, this message translates to:
  /// **'Time / Div'**
  String get timePerDiv;

  /// No description provided for @oscilloscopeDesc.
  ///
  /// In en, this message translates to:
  /// **'An oscilloscope is a diagnostic instrument that visualizes electrical voltage signals as waveforms over time.'**
  String get oscilloscopeDesc;

  /// No description provided for @voltsDivDesc.
  ///
  /// In en, this message translates to:
  /// **'Volts/Div adjusts the vertical scale (amplitude). Higher values make the wave look smaller.'**
  String get voltsDivDesc;

  /// No description provided for @timeDivDesc.
  ///
  /// In en, this message translates to:
  /// **'Time/Div adjusts the horizontal scale (time). It changes how many cycles you see on screen.'**
  String get timeDivDesc;

  /// No description provided for @gridDesc.
  ///
  /// In en, this message translates to:
  /// **'The grid helps you measure peak voltage (Vp) and the period of the wave.'**
  String get gridDesc;

  /// No description provided for @transformerTheory.
  ///
  /// In en, this message translates to:
  /// **'TRANSFORMER THEORY'**
  String get transformerTheory;

  /// No description provided for @whatIsTransformer.
  ///
  /// In en, this message translates to:
  /// **'What is a Transformer?'**
  String get whatIsTransformer;

  /// No description provided for @transformerDesc.
  ///
  /// In en, this message translates to:
  /// **'A transformer is a device that transfers electrical energy between two or more circuits through electromagnetic induction.'**
  String get transformerDesc;

  /// No description provided for @stepUp.
  ///
  /// In en, this message translates to:
  /// **'Step-Up'**
  String get stepUp;

  /// No description provided for @stepDown.
  ///
  /// In en, this message translates to:
  /// **'Step-Down'**
  String get stepDown;

  /// No description provided for @primaryCoil.
  ///
  /// In en, this message translates to:
  /// **'Primary Coil'**
  String get primaryCoil;

  /// No description provided for @secondaryCoil.
  ///
  /// In en, this message translates to:
  /// **'Secondary Coil'**
  String get secondaryCoil;

  /// No description provided for @turnsRatio.
  ///
  /// In en, this message translates to:
  /// **'Turns Ratio'**
  String get turnsRatio;

  /// No description provided for @voltageIn.
  ///
  /// In en, this message translates to:
  /// **'Voltage In'**
  String get voltageIn;

  /// No description provided for @voltageOut.
  ///
  /// In en, this message translates to:
  /// **'Voltage Out'**
  String get voltageOut;

  /// No description provided for @impedanceZ.
  ///
  /// In en, this message translates to:
  /// **'Impedance (Z)'**
  String get impedanceZ;

  /// No description provided for @phase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get phase;

  /// No description provided for @upgradeToUnlock.
  ///
  /// In en, this message translates to:
  /// **'UPGRADE TO UNLOCK PERMANENTLY'**
  String get upgradeToUnlock;

  /// No description provided for @watchAdToUnlock.
  ///
  /// In en, this message translates to:
  /// **'WATCH AD TO UNLOCK (10 MINS)'**
  String get watchAdToUnlock;

  /// No description provided for @scientificProTier.
  ///
  /// In en, this message translates to:
  /// **'This lab is available in the Scientific Pro tier. You can also unlock it temporarily by watching a short ad.'**
  String get scientificProTier;

  /// No description provided for @expertLabProTier.
  ///
  /// In en, this message translates to:
  /// **'This expert lab is available in the Scientific Pro tier.'**
  String get expertLabProTier;

  /// No description provided for @scientificPro.
  ///
  /// In en, this message translates to:
  /// **'SCIENTIFIC PRO'**
  String get scientificPro;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'BACK TO MENU'**
  String get backToMenu;

  /// No description provided for @proFeatures.
  ///
  /// In en, this message translates to:
  /// **'Pro Features'**
  String get proFeatures;

  /// No description provided for @inductanceL.
  ///
  /// In en, this message translates to:
  /// **'Inductance (L)'**
  String get inductanceL;

  /// No description provided for @capacitanceC.
  ///
  /// In en, this message translates to:
  /// **'Capacitance (C)'**
  String get capacitanceC;

  /// No description provided for @rlcTheory.
  ///
  /// In en, this message translates to:
  /// **'RLC THEORY'**
  String get rlcTheory;

  /// No description provided for @whatIsRlc.
  ///
  /// In en, this message translates to:
  /// **'What is RLC?'**
  String get whatIsRlc;

  /// No description provided for @impedance.
  ///
  /// In en, this message translates to:
  /// **'Impedance'**
  String get impedance;

  /// No description provided for @resonance.
  ///
  /// In en, this message translates to:
  /// **'Resonance'**
  String get resonance;

  /// No description provided for @transformerGuide.
  ///
  /// In en, this message translates to:
  /// **'Transformer Guide'**
  String get transformerGuide;

  /// No description provided for @primaryCoilDesc.
  ///
  /// In en, this message translates to:
  /// **'The Primary turns (Np) determine the number of wire loops on the input side.'**
  String get primaryCoilDesc;

  /// No description provided for @secondaryCoilDesc.
  ///
  /// In en, this message translates to:
  /// **'The Secondary turns (Ns) determine the loops on the output side.'**
  String get secondaryCoilDesc;

  /// No description provided for @turnsRatioDesc.
  ///
  /// In en, this message translates to:
  /// **'Turns Ratio (Ns/Np) defines the voltage transformation. If Ns > Np, it steps up voltage.'**
  String get turnsRatioDesc;

  /// No description provided for @simulationDesc.
  ///
  /// In en, this message translates to:
  /// **'The simulation shows the real-time conversion from Primary Vp to Secondary Vp based on your settings.'**
  String get simulationDesc;

  /// No description provided for @rlcGuide.
  ///
  /// In en, this message translates to:
  /// **'RLC Reactive Guide'**
  String get rlcGuide;

  /// No description provided for @rlcDesc.
  ///
  /// In en, this message translates to:
  /// **'The RLC lab explores how resistance (R), inductance (L), and capacitance (C) affect AC current.'**
  String get rlcDesc;

  /// No description provided for @inductanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Inductor (L) opposes changes in current and stores energy in a magnetic field.'**
  String get inductanceDesc;

  /// No description provided for @capacitanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Capacitor (C) stores energy in an electric field and blocks DC while allowing AC to pass.'**
  String get capacitanceDesc;

  /// No description provided for @impedanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Impedance (Z) is the total opposition to AC current, combining resistance and reactance.'**
  String get impedanceDesc;

  /// No description provided for @whatIsIt.
  ///
  /// In en, this message translates to:
  /// **'What is it?'**
  String get whatIsIt;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it Works'**
  String get howItWorks;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'GOT IT'**
  String get gotIt;

  /// No description provided for @acElectricityLabTitle.
  ///
  /// In en, this message translates to:
  /// **'AC ELECTRICITY LAB'**
  String get acElectricityLabTitle;

  /// No description provided for @acTheory.
  ///
  /// In en, this message translates to:
  /// **'AC THEORY'**
  String get acTheory;

  /// No description provided for @whatIsAc.
  ///
  /// In en, this message translates to:
  /// **'What is AC?'**
  String get whatIsAc;

  /// No description provided for @keyConcepts.
  ///
  /// In en, this message translates to:
  /// **'Key Concepts:'**
  String get keyConcepts;

  /// No description provided for @mainsHum.
  ///
  /// In en, this message translates to:
  /// **'Mains Hum (Haptic)'**
  String get mainsHum;

  /// No description provided for @oscilloscope.
  ///
  /// In en, this message translates to:
  /// **'Oscilloscope'**
  String get oscilloscope;

  /// No description provided for @rlcLab.
  ///
  /// In en, this message translates to:
  /// **'RLC Lab'**
  String get rlcLab;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @peakVoltageVp.
  ///
  /// In en, this message translates to:
  /// **'Peak Voltage (Vp)'**
  String get peakVoltageVp;

  /// No description provided for @frequencyHz.
  ///
  /// In en, this message translates to:
  /// **'Frequency (Hz)'**
  String get frequencyHz;

  /// No description provided for @voltsDiv.
  ///
  /// In en, this message translates to:
  /// **'Volts / Div'**
  String get voltsDiv;

  /// No description provided for @timeDiv.
  ///
  /// In en, this message translates to:
  /// **'Time / Div'**
  String get timeDiv;

  /// No description provided for @primaryVp.
  ///
  /// In en, this message translates to:
  /// **'Primary Vp'**
  String get primaryVp;

  /// No description provided for @secondaryVp.
  ///
  /// In en, this message translates to:
  /// **'Secondary Vp'**
  String get secondaryVp;

  /// No description provided for @ratio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get ratio;

  /// No description provided for @inductance.
  ///
  /// In en, this message translates to:
  /// **'Inductance'**
  String get inductance;

  /// No description provided for @capacitance.
  ///
  /// In en, this message translates to:
  /// **'Capacitance'**
  String get capacitance;

  /// No description provided for @avgPower.
  ///
  /// In en, this message translates to:
  /// **'Avg Power'**
  String get avgPower;

  /// No description provided for @rmsVoltage.
  ///
  /// In en, this message translates to:
  /// **'RMS Voltage'**
  String get rmsVoltage;

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

  /// No description provided for @peakVoltage.
  ///
  /// In en, this message translates to:
  /// **'Peak Voltage'**
  String get peakVoltage;

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

  /// No description provided for @waveType.
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get waveType;

  /// No description provided for @alternatingCurrent.
  ///
  /// In en, this message translates to:
  /// **'Alternating Current (AC) is a type of electrical current in which the direction of the flow of electrons switches back and forth at regular intervals or cycles.'**
  String get alternatingCurrent;

  /// No description provided for @peakVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Vp (Peak Voltage): The maximum voltage reached in a cycle.'**
  String get peakVoltageDesc;

  /// No description provided for @frequencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Frequency (Hz): How many cycles occur per second.'**
  String get frequencyDesc;

  /// No description provided for @vrmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Vrms: The effective voltage (heating power) equivalent to DC.'**
  String get vrmsDesc;

  /// No description provided for @phasorDesc.
  ///
  /// In en, this message translates to:
  /// **'Phasor: A rotating vector that visualizes the sine wave phase.'**
  String get phasorDesc;

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

  /// No description provided for @enterLab.
  ///
  /// In en, this message translates to:
  /// **'ENTER LAB'**
  String get enterLab;

  /// No description provided for @formulaReference.
  ///
  /// In en, this message translates to:
  /// **'FORMULA REFERENCE'**
  String get formulaReference;

  /// No description provided for @controls.
  ///
  /// In en, this message translates to:
  /// **'CONTROLS'**
  String get controls;

  /// No description provided for @educationTools.
  ///
  /// In en, this message translates to:
  /// **'EDUCATION TOOLS'**
  String get educationTools;

  /// No description provided for @blueprintHud.
  ///
  /// In en, this message translates to:
  /// **'BLUEPRINT HUD'**
  String get blueprintHud;

  /// No description provided for @wave1Amplitude.
  ///
  /// In en, this message translates to:
  /// **'Wave 1 Amplitude'**
  String get wave1Amplitude;

  /// No description provided for @wave2Amplitude.
  ///
  /// In en, this message translates to:
  /// **'Wave 2 Amplitude'**
  String get wave2Amplitude;

  /// No description provided for @wave1Frequency.
  ///
  /// In en, this message translates to:
  /// **'Wave 1 Frequency'**
  String get wave1Frequency;

  /// No description provided for @wave2Frequency.
  ///
  /// In en, this message translates to:
  /// **'Wave 2 Frequency'**
  String get wave2Frequency;

  /// No description provided for @harmonicN.
  ///
  /// In en, this message translates to:
  /// **'Harmonic (n)'**
  String get harmonicN;

  /// No description provided for @phaseDiff.
  ///
  /// In en, this message translates to:
  /// **'Phase Diff (φ)'**
  String get phaseDiff;

  /// No description provided for @sourceVelocity.
  ///
  /// In en, this message translates to:
  /// **'Source Velocity (vs)'**
  String get sourceVelocity;

  /// No description provided for @waveMode.
  ///
  /// In en, this message translates to:
  /// **'Wave Mode'**
  String get waveMode;

  /// No description provided for @presetSpeed.
  ///
  /// In en, this message translates to:
  /// **'Preset Speed'**
  String get presetSpeed;

  /// No description provided for @captureGhost.
  ///
  /// In en, this message translates to:
  /// **'Capture Ghost'**
  String get captureGhost;

  /// No description provided for @clearGhost.
  ///
  /// In en, this message translates to:
  /// **'Clear Ghost'**
  String get clearGhost;

  /// No description provided for @showGhost.
  ///
  /// In en, this message translates to:
  /// **'Show Ghost'**
  String get showGhost;

  /// No description provided for @dopplerEffect.
  ///
  /// In en, this message translates to:
  /// **'Doppler Effect'**
  String get dopplerEffect;

  /// No description provided for @approaching.
  ///
  /// In en, this message translates to:
  /// **'Approaching'**
  String get approaching;

  /// No description provided for @receding.
  ///
  /// In en, this message translates to:
  /// **'Receding'**
  String get receding;

  /// No description provided for @wavelengthGreater.
  ///
  /// In en, this message translates to:
  /// **'Wavelength (> canvas)'**
  String get wavelengthGreater;

  /// No description provided for @resultantAmplitude.
  ///
  /// In en, this message translates to:
  /// **'Resultant Amplitude'**
  String get resultantAmplitude;

  /// No description provided for @mathDerivations.
  ///
  /// In en, this message translates to:
  /// **'Math Derivations'**
  String get mathDerivations;

  /// No description provided for @formulaReferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Formula Reference'**
  String get formulaReferenceTitle;

  /// No description provided for @fundamentalEquations.
  ///
  /// In en, this message translates to:
  /// **'Fundamental Equations'**
  String get fundamentalEquations;

  /// No description provided for @waveEquation.
  ///
  /// In en, this message translates to:
  /// **'Wave Speed'**
  String get waveEquation;

  /// No description provided for @periodEquation.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get periodEquation;

  /// No description provided for @angularFrequency.
  ///
  /// In en, this message translates to:
  /// **'Angular Frequency'**
  String get angularFrequency;

  /// No description provided for @waveNumber.
  ///
  /// In en, this message translates to:
  /// **'Wave Number'**
  String get waveNumber;

  /// No description provided for @wavePropagation.
  ///
  /// In en, this message translates to:
  /// **'Wave Propagation'**
  String get wavePropagation;

  /// No description provided for @travelingWave.
  ///
  /// In en, this message translates to:
  /// **'Traveling Wave'**
  String get travelingWave;

  /// No description provided for @standingWaveEquation.
  ///
  /// In en, this message translates to:
  /// **'Standing Wave'**
  String get standingWaveEquation;

  /// No description provided for @advancedPhysics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Physics'**
  String get advancedPhysics;

  /// No description provided for @dampedWave.
  ///
  /// In en, this message translates to:
  /// **'Damped Wave'**
  String get dampedWave;

  /// No description provided for @waveSpeedVars.
  ///
  /// In en, this message translates to:
  /// **'v: Velocity (m/s), f: Frequency (Hz), λ: Wavelength (m)'**
  String get waveSpeedVars;

  /// No description provided for @periodVars.
  ///
  /// In en, this message translates to:
  /// **'T: Period (s), f: Frequency (Hz)'**
  String get periodVars;

  /// No description provided for @angularFrequencyVars.
  ///
  /// In en, this message translates to:
  /// **'ω: Angular Frequency (rad/s), f: Frequency (Hz)'**
  String get angularFrequencyVars;

  /// No description provided for @waveNumberVars.
  ///
  /// In en, this message translates to:
  /// **'k: Wave Number (rad/m), λ: Wavelength (m)'**
  String get waveNumberVars;

  /// No description provided for @travelingWaveVars.
  ///
  /// In en, this message translates to:
  /// **'y: Displacement, A: Amplitude, x: Position, t: Time'**
  String get travelingWaveVars;

  /// No description provided for @standingWaveVars.
  ///
  /// In en, this message translates to:
  /// **'λ_n = 2L / n (for n-th harmonic)'**
  String get standingWaveVars;

  /// No description provided for @dopplerEffectVars.
  ///
  /// In en, this message translates to:
  /// **'f\': Observed Frequency, v_s: Source Velocity'**
  String get dopplerEffectVars;

  /// No description provided for @dampedWaveVars.
  ///
  /// In en, this message translates to:
  /// **'γ: Damping coefficient'**
  String get dampedWaveVars;

  /// No description provided for @mathDerivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Mathematical Derivations'**
  String get mathDerivationTitle;

  /// No description provided for @mathLiveValues.
  ///
  /// In en, this message translates to:
  /// **'Live simulation values injected below'**
  String get mathLiveValues;

  /// No description provided for @mathWaveEquation.
  ///
  /// In en, this message translates to:
  /// **'1. The Wave Equation'**
  String get mathWaveEquation;

  /// No description provided for @mathWaveEquationDesc.
  ///
  /// In en, this message translates to:
  /// **'General equation for a sinusoidal wave:'**
  String get mathWaveEquationDesc;

  /// No description provided for @mathStandingCondition.
  ///
  /// In en, this message translates to:
  /// **'2. Standing Wave Condition'**
  String get mathStandingCondition;

  /// No description provided for @mathStandingConditionDesc.
  ///
  /// In en, this message translates to:
  /// **'For a string of length L, the wavelength for harmonic n is λ = 2L/n.'**
  String get mathStandingConditionDesc;

  /// No description provided for @mathParticleVelocity.
  ///
  /// In en, this message translates to:
  /// **'3. Particle Velocity'**
  String get mathParticleVelocity;

  /// No description provided for @mathParticleVelocityDesc.
  ///
  /// In en, this message translates to:
  /// **'Rate of change of displacement (∂y/∂t):'**
  String get mathParticleVelocityDesc;

  /// No description provided for @mathWaveParameters.
  ///
  /// In en, this message translates to:
  /// **'4. Wave Parameters'**
  String get mathWaveParameters;

  /// No description provided for @mathWaveParametersDesc.
  ///
  /// In en, this message translates to:
  /// **'Relationship between speed, frequency, and wavelength:'**
  String get mathWaveParametersDesc;

  /// No description provided for @mathCurrentValues.
  ///
  /// In en, this message translates to:
  /// **'Current Values'**
  String get mathCurrentValues;

  /// No description provided for @mathAmplitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Amplitude'**
  String get mathAmplitudeLabel;

  /// No description provided for @mathFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get mathFrequencyLabel;

  /// No description provided for @mathSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get mathSpeedLabel;

  /// No description provided for @mathWavelengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Wavelength'**
  String get mathWavelengthLabel;

  /// No description provided for @mathAngularFreqLabel.
  ///
  /// In en, this message translates to:
  /// **'Angular Freq'**
  String get mathAngularFreqLabel;

  /// No description provided for @mathWaveNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Wave Number'**
  String get mathWaveNumberLabel;

  /// No description provided for @presetsVacuum.
  ///
  /// In en, this message translates to:
  /// **'Vacuum'**
  String get presetsVacuum;

  /// No description provided for @presetsAir.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get presetsAir;

  /// No description provided for @presetsWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get presetsWater;

  /// No description provided for @challengeGuide.
  ///
  /// In en, this message translates to:
  /// **'Challenge Guide'**
  String get challengeGuide;

  /// No description provided for @challengeHelp1.
  ///
  /// In en, this message translates to:
  /// **'The most basic challenge. Your goal is to match the raw frequency of the wave.'**
  String get challengeHelp1;

  /// No description provided for @challengeHelp2.
  ///
  /// In en, this message translates to:
  /// **'The goal is defined by the harmonic number \'n\'.'**
  String get challengeHelp2;

  /// No description provided for @challengeHelp3.
  ///
  /// In en, this message translates to:
  /// **'The goal is defined by the phase difference in terms of π.'**
  String get challengeHelp3;

  /// No description provided for @challengeGoal1.
  ///
  /// In en, this message translates to:
  /// **'Match the frequency within 0.2 Hz'**
  String get challengeGoal1;

  /// No description provided for @challengeGoal2.
  ///
  /// In en, this message translates to:
  /// **'Switch to Standing Wave and set the correct Harmonic'**
  String get challengeGoal2;

  /// No description provided for @challengeGoal3.
  ///
  /// In en, this message translates to:
  /// **'Switch to Interference and adjust Phase Difference'**
  String get challengeGoal3;

  /// No description provided for @masterTheWaves.
  ///
  /// In en, this message translates to:
  /// **'Master the Waves'**
  String get masterTheWaves;

  /// No description provided for @challengeModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Challenge mode tests your understanding of wave physics. There are three different types of puzzles you will encounter.'**
  String get challengeModeDescription;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// No description provided for @matchFreqTarget.
  ///
  /// In en, this message translates to:
  /// **'Look at the target frequency (e.g., 5.0 Hz).'**
  String get matchFreqTarget;

  /// No description provided for @useSliderAdjust.
  ///
  /// In en, this message translates to:
  /// **'Use the slider to adjust the wave frequency.'**
  String get useSliderAdjust;

  /// No description provided for @matchWithin.
  ///
  /// In en, this message translates to:
  /// **'Match it within 0.2 Hz to score!'**
  String get matchWithin;

  /// No description provided for @switchStanding.
  ///
  /// In en, this message translates to:
  /// **'First, switch the wave mode to \'Standing\'.'**
  String get switchStanding;

  /// No description provided for @selectNValue.
  ///
  /// In en, this message translates to:
  /// **'Select the \'n\' value that matches the target.'**
  String get selectNValue;

  /// No description provided for @switchInterference.
  ///
  /// In en, this message translates to:
  /// **'First, switch the wave mode to \'Interference\'.'**
  String get switchInterference;

  /// No description provided for @adjustPhase.
  ///
  /// In en, this message translates to:
  /// **'Adjust the Phase Difference slider until you hit the target (e.g., 0.50 π).'**
  String get adjustPhase;

  /// No description provided for @starterLab.
  ///
  /// In en, this message translates to:
  /// **'STARTER LAB'**
  String get starterLab;

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

  /// No description provided for @thirdLaw.
  ///
  /// In en, this message translates to:
  /// **'Third Law'**
  String get thirdLaw;

  /// No description provided for @zerothLaw.
  ///
  /// In en, this message translates to:
  /// **'Zeroth Law'**
  String get zerothLaw;

  /// No description provided for @theSecondLaw.
  ///
  /// In en, this message translates to:
  /// **'The Second Law'**
  String get theSecondLaw;

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

  /// No description provided for @cookingPan.
  ///
  /// In en, this message translates to:
  /// **'Cooking pan'**
  String get cookingPan;

  /// No description provided for @cookingPanDesc.
  ///
  /// In en, this message translates to:
  /// **'Metal pan conducts heat from the stove burner directly to your food.'**
  String get cookingPanDesc;

  /// No description provided for @oceanCurrents.
  ///
  /// In en, this message translates to:
  /// **'Ocean currents'**
  String get oceanCurrents;

  /// No description provided for @oceanCurrentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm water rises, cold water sinks — global convection that drives climate.'**
  String get oceanCurrentsDesc;

  /// No description provided for @solarRadiation.
  ///
  /// In en, this message translates to:
  /// **'Solar radiation'**
  String get solarRadiation;

  /// No description provided for @solarRadiationDesc.
  ///
  /// In en, this message translates to:
  /// **'The Sun heats Earth through radiation — no medium needed across space.'**
  String get solarRadiationDesc;

  /// No description provided for @bicyclePump.
  ///
  /// In en, this message translates to:
  /// **'Bicycle pump'**
  String get bicyclePump;

  /// No description provided for @bicyclePumpDesc.
  ///
  /// In en, this message translates to:
  /// **'Compressing air (Boyle\'s Law) increases pressure to inflate the tyre.'**
  String get bicyclePumpDesc;

  /// No description provided for @hotAirBalloon.
  ///
  /// In en, this message translates to:
  /// **'Hot air balloon'**
  String get hotAirBalloon;

  /// No description provided for @hotAirBalloonDesc.
  ///
  /// In en, this message translates to:
  /// **'Heating air (Charles\'s Law) increases volume, reducing density so it floats.'**
  String get hotAirBalloonDesc;

  /// No description provided for @pressureCooker.
  ///
  /// In en, this message translates to:
  /// **'Pressure cooker'**
  String get pressureCooker;

  /// No description provided for @pressureCookerDesc.
  ///
  /// In en, this message translates to:
  /// **'Increased temperature at fixed volume (Gay-Lussac\'s Law) leads to higher pressure for faster cooking.'**
  String get pressureCookerDesc;

  /// No description provided for @carEngine.
  ///
  /// In en, this message translates to:
  /// **'Car engine'**
  String get carEngine;

  /// No description provided for @carEngineDesc.
  ///
  /// In en, this message translates to:
  /// **'Combustion engines are heat engines — fuel burns (hot reservoir), exhaust cools (cold reservoir).'**
  String get carEngineDesc;

  /// No description provided for @refrigerator.
  ///
  /// In en, this message translates to:
  /// **'Refrigerator'**
  String get refrigerator;

  /// No description provided for @refrigeratorDesc.
  ///
  /// In en, this message translates to:
  /// **'A heat pump running in reverse — moves heat from cold (inside) to hot (room).'**
  String get refrigeratorDesc;

  /// No description provided for @powerPlant.
  ///
  /// In en, this message translates to:
  /// **'Power plant'**
  String get powerPlant;

  /// No description provided for @powerPlantDesc.
  ///
  /// In en, this message translates to:
  /// **'Steam turbines are large Carnot-like engines. Higher steam temperature = better efficiency.'**
  String get powerPlantDesc;

  /// No description provided for @sweating.
  ///
  /// In en, this message translates to:
  /// **'Sweating'**
  String get sweating;

  /// No description provided for @sweatingDesc.
  ///
  /// In en, this message translates to:
  /// **'Sweat evaporates from skin. Evaporation absorbs body heat — that\'s how you cool down.'**
  String get sweatingDesc;

  /// No description provided for @icePacks.
  ///
  /// In en, this message translates to:
  /// **'Ice packs'**
  String get icePacks;

  /// No description provided for @icePacksDesc.
  ///
  /// In en, this message translates to:
  /// **'Melting ice absorbs latent heat from injuries to reduce swelling.'**
  String get icePacksDesc;

  /// No description provided for @cloudsForming.
  ///
  /// In en, this message translates to:
  /// **'Clouds forming'**
  String get cloudsForming;

  /// No description provided for @cloudsFormingDesc.
  ///
  /// In en, this message translates to:
  /// **'Water vapor condenses (releases latent heat) to form clouds and rain.'**
  String get cloudsFormingDesc;

  /// No description provided for @iceMelting.
  ///
  /// In en, this message translates to:
  /// **'Ice melting'**
  String get iceMelting;

  /// No description provided for @iceMeltingDesc.
  ///
  /// In en, this message translates to:
  /// **'Ordered ice crystals become disordered liquid water — entropy increases spontaneously.'**
  String get iceMeltingDesc;

  /// No description provided for @perfumeSpreading.
  ///
  /// In en, this message translates to:
  /// **'Perfume spreading'**
  String get perfumeSpreading;

  /// No description provided for @perfumeSpreadingDesc.
  ///
  /// In en, this message translates to:
  /// **'Molecules spread from high to low concentration — nature always increases disorder.'**
  String get perfumeSpreadingDesc;

  /// No description provided for @rustingDecay.
  ///
  /// In en, this message translates to:
  /// **'Rusting & decay'**
  String get rustingDecay;

  /// No description provided for @rustingDecayDesc.
  ///
  /// In en, this message translates to:
  /// **'Ordered matter spontaneously breaks down into disorder. You need energy to reverse it.'**
  String get rustingDecayDesc;

  /// No description provided for @realWorld.
  ///
  /// In en, this message translates to:
  /// **'Real World'**
  String get realWorld;

  /// No description provided for @thermalEquilibrium.
  ///
  /// In en, this message translates to:
  /// **'Thermal Equilibrium'**
  String get thermalEquilibrium;

  /// No description provided for @zerothLawStatement.
  ///
  /// In en, this message translates to:
  /// **'If A is in thermal equilibrium with B, and B with C, then A is in thermal equilibrium with C.'**
  String get zerothLawStatement;

  /// No description provided for @zerothLawFormula.
  ///
  /// In en, this message translates to:
  /// **'T_A = T_B = T_C'**
  String get zerothLawFormula;

  /// No description provided for @zerothLawExplanation.
  ///
  /// In en, this message translates to:
  /// **'This is the basis of temperature measurement. Objects in contact eventually reach the same temperature.'**
  String get zerothLawExplanation;

  /// No description provided for @zerothLawRealWorld.
  ///
  /// In en, this message translates to:
  /// **'A thermometer works because it reaches thermal equilibrium with your body — then reads that shared temperature.'**
  String get zerothLawRealWorld;

  /// No description provided for @firstLawThermo.
  ///
  /// In en, this message translates to:
  /// **'First Law'**
  String get firstLawThermo;

  /// No description provided for @conservationOfEnergy.
  ///
  /// In en, this message translates to:
  /// **'Conservation of Energy'**
  String get conservationOfEnergy;

  /// No description provided for @firstLawStatement.
  ///
  /// In en, this message translates to:
  /// **'Energy cannot be created or destroyed — only converted from one form to another.'**
  String get firstLawStatement;

  /// No description provided for @firstLawExplanation.
  ///
  /// In en, this message translates to:
  /// **'The internal energy (ΔU) of a system changes by heat added (Q) minus work done by the system (W).'**
  String get firstLawExplanation;

  /// No description provided for @firstLawRealWorld.
  ///
  /// In en, this message translates to:
  /// **'A car engine converts fuel\'s chemical energy → heat → mechanical work. Total energy is conserved.'**
  String get firstLawRealWorld;

  /// No description provided for @secondLawThermo.
  ///
  /// In en, this message translates to:
  /// **'Second Law'**
  String get secondLawThermo;

  /// No description provided for @entropyAlwaysIncreases.
  ///
  /// In en, this message translates to:
  /// **'Entropy Always Increases'**
  String get entropyAlwaysIncreases;

  /// No description provided for @secondLawStatement.
  ///
  /// In en, this message translates to:
  /// **'The total entropy of an isolated system always increases over time.'**
  String get secondLawStatement;

  /// No description provided for @secondLawFormula.
  ///
  /// In en, this message translates to:
  /// **'ΔS_universe ≥ 0'**
  String secondLawFormula(Object universe);

  /// No description provided for @secondLawExplanation.
  ///
  /// In en, this message translates to:
  /// **'Natural processes go from order to disorder. You can\'t build a perfect engine — some energy is always wasted as heat.'**
  String get secondLawExplanation;

  /// No description provided for @secondLawRealWorld.
  ///
  /// In en, this message translates to:
  /// **'Your room gets messy by itself. Cleaning it (reversing disorder) requires energy input — you can\'t get that for free.'**
  String get secondLawRealWorld;

  /// No description provided for @thirdLawThermo.
  ///
  /// In en, this message translates to:
  /// **'Third Law'**
  String get thirdLawThermo;

  /// No description provided for @thirdLawStatement.
  ///
  /// In en, this message translates to:
  /// **'The entropy of a perfect crystal at absolute zero (0 K = -273.15°C) is exactly zero.'**
  String get thirdLawStatement;

  /// No description provided for @thirdLawFormula.
  ///
  /// In en, this message translates to:
  /// **'S → 0 as T → 0 K'**
  String get thirdLawFormula;

  /// No description provided for @thirdLawExplanation.
  ///
  /// In en, this message translates to:
  /// **'At absolute zero, all motion stops and perfect order exists. You can never actually reach absolute zero.'**
  String get thirdLawExplanation;

  /// No description provided for @thirdLawRealWorld.
  ///
  /// In en, this message translates to:
  /// **'Scientists cool atoms to within billionths of a degree of absolute zero — but can never fully reach it.'**
  String get thirdLawRealWorld;

  /// No description provided for @mathematicalFormula.
  ///
  /// In en, this message translates to:
  /// **'Mathematical Formula'**
  String get mathematicalFormula;

  /// No description provided for @entropyExplanation.
  ///
  /// In en, this message translates to:
  /// **'Nature always tends toward disorder. Once the wall is removed, the red and blue particles will spread until they are uniformly mixed. They will never spontaneously un-mix!'**
  String get entropyExplanation;

  /// No description provided for @removePartition.
  ///
  /// In en, this message translates to:
  /// **'REMOVE PARTITION'**
  String get removePartition;

  /// No description provided for @atomicLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Atomic Lab'**
  String get atomicLabTitle;

  /// No description provided for @atomicLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Chemistry Simulations'**
  String get atomicLabSubtitle;

  /// No description provided for @bohrModelTitle.
  ///
  /// In en, this message translates to:
  /// **'Bohr Model'**
  String get bohrModelTitle;

  /// No description provided for @bohrModelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Animate electrons orbiting'**
  String get bohrModelSubtitle;

  /// No description provided for @electronConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Electron Config'**
  String get electronConfigTitle;

  /// No description provided for @electronConfigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill orbitals step by step'**
  String get electronConfigSubtitle;

  /// No description provided for @moleculesTitle.
  ///
  /// In en, this message translates to:
  /// **'3D Molecules'**
  String get moleculesTitle;

  /// No description provided for @moleculesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rotate ball-and-stick models'**
  String get moleculesSubtitle;

  /// No description provided for @vseprTitle.
  ///
  /// In en, this message translates to:
  /// **'VSEPR Shapes'**
  String get vseprTitle;

  /// No description provided for @vseprSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Geometry from electron pairs'**
  String get vseprSubtitle;

  /// No description provided for @orbitalViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Orbital Viewer'**
  String get orbitalViewerTitle;

  /// No description provided for @orbitalViewerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore s, p, d probability regions'**
  String get orbitalViewerSubtitle;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock Bohr Model and remove ads!'**
  String get upgradeToPremium;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @builtForChemistry.
  ///
  /// In en, this message translates to:
  /// **'Built for Chemistry Students'**
  String get builtForChemistry;

  /// No description provided for @selectElementPro.
  ///
  /// In en, this message translates to:
  /// **'Select Element (1-36)'**
  String get selectElementPro;

  /// No description provided for @selectElementFree.
  ///
  /// In en, this message translates to:
  /// **'Select Element (1-10)'**
  String get selectElementFree;

  /// No description provided for @selectElement.
  ///
  /// In en, this message translates to:
  /// **'Select Element'**
  String get selectElement;

  /// No description provided for @angle.
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get angle;

  /// No description provided for @stericNumber.
  ///
  /// In en, this message translates to:
  /// **'Steric #'**
  String get stericNumber;

  /// No description provided for @bonds.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get bonds;

  /// No description provided for @lonePairs.
  ///
  /// In en, this message translates to:
  /// **'Lone Pairs'**
  String get lonePairs;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples:'**
  String get examples;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @valence.
  ///
  /// In en, this message translates to:
  /// **'Valence'**
  String get valence;

  /// No description provided for @elementCategoryNonmetal.
  ///
  /// In en, this message translates to:
  /// **'Nonmetal'**
  String get elementCategoryNonmetal;

  /// No description provided for @elementCategoryNobleGas.
  ///
  /// In en, this message translates to:
  /// **'Noble gas'**
  String get elementCategoryNobleGas;

  /// No description provided for @elementCategoryAlkaliMetal.
  ///
  /// In en, this message translates to:
  /// **'Alkali metal'**
  String get elementCategoryAlkaliMetal;

  /// No description provided for @elementCategoryAlkalineEarth.
  ///
  /// In en, this message translates to:
  /// **'Alkaline earth metal'**
  String get elementCategoryAlkalineEarth;

  /// No description provided for @elementCategoryMetalloid.
  ///
  /// In en, this message translates to:
  /// **'Metalloid'**
  String get elementCategoryMetalloid;

  /// No description provided for @elementCategoryHalogen.
  ///
  /// In en, this message translates to:
  /// **'Halogen'**
  String get elementCategoryHalogen;

  /// No description provided for @elementCategoryTransitionMetal.
  ///
  /// In en, this message translates to:
  /// **'Transition metal'**
  String get elementCategoryTransitionMetal;

  /// No description provided for @elementCategoryPostTransition.
  ///
  /// In en, this message translates to:
  /// **'Post-transition metal'**
  String get elementCategoryPostTransition;

  /// No description provided for @orbitalFilling.
  ///
  /// In en, this message translates to:
  /// **'Orbital Filling'**
  String get orbitalFilling;

  /// No description provided for @hundsRule.
  ///
  /// In en, this message translates to:
  /// **'Hund\'s Rule'**
  String get hundsRule;

  /// No description provided for @switchElement.
  ///
  /// In en, this message translates to:
  /// **'Switch Element'**
  String get switchElement;

  /// No description provided for @fullConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Full Configuration'**
  String get fullConfiguration;

  /// No description provided for @animateElectrons.
  ///
  /// In en, this message translates to:
  /// **'Animate electrons orbiting'**
  String get animateElectrons;

  /// No description provided for @unlockForPro.
  ///
  /// In en, this message translates to:
  /// **'PRO - Unlock for unlimited access'**
  String get unlockForPro;

  /// No description provided for @fillOrbitalsStep.
  ///
  /// In en, this message translates to:
  /// **'Fill orbitals step by step'**
  String get fillOrbitalsStep;

  /// No description provided for @rotateModels.
  ///
  /// In en, this message translates to:
  /// **'Rotate ball-and-stick models'**
  String get rotateModels;

  /// No description provided for @upgradeToUnlock36.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to PRO to unlock all 36 elements!'**
  String get upgradeToUnlock36;

  /// No description provided for @vseprLinear.
  ///
  /// In en, this message translates to:
  /// **'Linear'**
  String get vseprLinear;

  /// No description provided for @vseprTrigonalPlanar.
  ///
  /// In en, this message translates to:
  /// **'Trigonal Planar'**
  String get vseprTrigonalPlanar;

  /// No description provided for @vseprBent120.
  ///
  /// In en, this message translates to:
  /// **'Bent (120°)'**
  String get vseprBent120;

  /// No description provided for @vseprTetrahedral.
  ///
  /// In en, this message translates to:
  /// **'Tetrahedral'**
  String get vseprTetrahedral;

  /// No description provided for @vseprTrigonalPyramidal.
  ///
  /// In en, this message translates to:
  /// **'Trigonal Pyramidal'**
  String get vseprTrigonalPyramidal;

  /// No description provided for @vseprBent104.
  ///
  /// In en, this message translates to:
  /// **'Bent (104.5°)'**
  String get vseprBent104;

  /// No description provided for @vseprOctahedral.
  ///
  /// In en, this message translates to:
  /// **'Octahedral'**
  String get vseprOctahedral;

  /// No description provided for @exciteOuterElectrons.
  ///
  /// In en, this message translates to:
  /// **'Excite outer electrons'**
  String get exciteOuterElectrons;

  /// No description provided for @factHydrogen.
  ///
  /// In en, this message translates to:
  /// **'Most abundant element in the universe. Forms H₂O with oxygen.'**
  String get factHydrogen;

  /// No description provided for @factHelium.
  ///
  /// In en, this message translates to:
  /// **'A completely full first shell makes helium the most stable element.'**
  String get factHelium;

  /// No description provided for @factLithium.
  ///
  /// In en, this message translates to:
  /// **'The lightest metal, used extensively in rechargeable batteries.'**
  String get factLithium;

  /// No description provided for @factBeryllium.
  ///
  /// In en, this message translates to:
  /// **'Found in gemstones like emerald and aquamarine.'**
  String get factBeryllium;

  /// No description provided for @factBoron.
  ///
  /// In en, this message translates to:
  /// **'Used in pyrotechnics to produce a distinctive green color.'**
  String get factBoron;

  /// No description provided for @factCarbon.
  ///
  /// In en, this message translates to:
  /// **'Tetravalent carbon is the backbone of all organic chemistry and life.'**
  String get factCarbon;

  /// No description provided for @factNitrogen.
  ///
  /// In en, this message translates to:
  /// **'Makes up about 78% of Earth\'s atmosphere as N₂ gas.'**
  String get factNitrogen;

  /// No description provided for @factOxygen.
  ///
  /// In en, this message translates to:
  /// **'Highly electronegative. Two lone pairs give water its bent shape.'**
  String get factOxygen;

  /// No description provided for @factFluorine.
  ///
  /// In en, this message translates to:
  /// **'The most reactive and electronegative of all elements.'**
  String get factFluorine;

  /// No description provided for @factNeon.
  ///
  /// In en, this message translates to:
  /// **'A full octet — neon does not form any chemical bonds naturally.'**
  String get factNeon;

  /// No description provided for @factSodium.
  ///
  /// In en, this message translates to:
  /// **'Extremely reactive soft metal that must be stored in oil.'**
  String get factSodium;

  /// No description provided for @factMagnesium.
  ///
  /// In en, this message translates to:
  /// **'Essential for photosynthesis as the central atom of chlorophyll.'**
  String get factMagnesium;

  /// No description provided for @factAluminum.
  ///
  /// In en, this message translates to:
  /// **'The most abundant metal in Earth\'s crust, widely used in recycling.'**
  String get factAluminum;

  /// No description provided for @factSilicon.
  ///
  /// In en, this message translates to:
  /// **'The semiconductor heart of modern electronics and computer chips.'**
  String get factSilicon;

  /// No description provided for @factPhosphorus.
  ///
  /// In en, this message translates to:
  /// **'Essential for life, forming the backbone of DNA and ATP.'**
  String get factPhosphorus;

  /// No description provided for @factSulfur.
  ///
  /// In en, this message translates to:
  /// **'Known since antiquity, often called \'brimstone\' in old texts.'**
  String get factSulfur;

  /// No description provided for @factChlorine.
  ///
  /// In en, this message translates to:
  /// **'One electron short of a full shell — very reactive, forms NaCl with sodium.'**
  String get factChlorine;

  /// No description provided for @factArgon.
  ///
  /// In en, this message translates to:
  /// **'The most common noble gas on Earth, used in incandescent light bulbs.'**
  String get factArgon;

  /// No description provided for @factPotassium.
  ///
  /// In en, this message translates to:
  /// **'Highly reactive metal found in abundance in bananas and seawater.'**
  String get factPotassium;

  /// No description provided for @factCalcium.
  ///
  /// In en, this message translates to:
  /// **'Essential for biological life, forming the structure of bones and teeth.'**
  String get factCalcium;

  /// No description provided for @factScandium.
  ///
  /// In en, this message translates to:
  /// **'Rare earth element used in high-strength aluminum alloys for aerospace.'**
  String get factScandium;

  /// No description provided for @factTitanium.
  ///
  /// In en, this message translates to:
  /// **'Known for its high strength-to-weight ratio and corrosion resistance.'**
  String get factTitanium;

  /// No description provided for @factVanadium.
  ///
  /// In en, this message translates to:
  /// **'Adds hardness and thermal stability to steel alloys.'**
  String get factVanadium;

  /// No description provided for @factChromium.
  ///
  /// In en, this message translates to:
  /// **'The main additive in stainless steel, providing its rust resistance.'**
  String get factChromium;

  /// No description provided for @factManganese.
  ///
  /// In en, this message translates to:
  /// **'Crucial for steel production and used in common alkaline batteries.'**
  String get factManganese;

  /// No description provided for @factIron.
  ///
  /// In en, this message translates to:
  /// **'The most common element on Earth by mass, forming the planet\'s core.'**
  String get factIron;

  /// No description provided for @factCobalt.
  ///
  /// In en, this message translates to:
  /// **'Essential for Vitamin B12 and used in high-performance magnets.'**
  String get factCobalt;

  /// No description provided for @factNickel.
  ///
  /// In en, this message translates to:
  /// **'Resists corrosion and is used in coinage and stainless steel.'**
  String get factNickel;

  /// No description provided for @factCopper.
  ///
  /// In en, this message translates to:
  /// **'Excellent electrical conductor, essential for modern wiring.'**
  String get factCopper;

  /// No description provided for @factZinc.
  ///
  /// In en, this message translates to:
  /// **'Used to galvanize steel to prevent rusting and in brass alloys.'**
  String get factZinc;

  /// No description provided for @factGallium.
  ///
  /// In en, this message translates to:
  /// **'Melts in your hand. Used in semiconductors like Gallium Arsenide.'**
  String get factGallium;

  /// No description provided for @factGermanium.
  ///
  /// In en, this message translates to:
  /// **'Early semiconductor material used before silicon became dominant.'**
  String get factGermanium;

  /// No description provided for @factArsenic.
  ///
  /// In en, this message translates to:
  /// **'Famous for its toxicity, it is also used in many metal alloys.'**
  String get factArsenic;

  /// No description provided for @factSelenium.
  ///
  /// In en, this message translates to:
  /// **'Photoconductive element used in glass production and nutrition.'**
  String get factSelenium;

  /// No description provided for @factBromine.
  ///
  /// In en, this message translates to:
  /// **'The only non-metallic element that exists as a liquid at room temperature.'**
  String get factBromine;

  /// No description provided for @factKrypton.
  ///
  /// In en, this message translates to:
  /// **'Used in lighting and photography for a brilliant white light.'**
  String get factKrypton;

  /// No description provided for @vseprLinearDesc.
  ///
  /// In en, this message translates to:
  /// **'Two bonding pairs, zero lone pairs. Atoms are arranged in a straight line for maximum separation.'**
  String get vseprLinearDesc;

  /// No description provided for @vseprTrigonalPlanarDesc.
  ///
  /// In en, this message translates to:
  /// **'Three bonds in a flat plane, equally spaced at 120° angles to minimize repulsion.'**
  String get vseprTrigonalPlanarDesc;

  /// No description provided for @vseprBent120Desc.
  ///
  /// In en, this message translates to:
  /// **'Two bonds and one lone pair. The lone pair pushes the bonds closer than 120°.'**
  String get vseprBent120Desc;

  /// No description provided for @vseprTetrahedralDesc.
  ///
  /// In en, this message translates to:
  /// **'Four bonds pointing to the corners of a regular tetrahedron. Highly symmetrical.'**
  String get vseprTetrahedralDesc;

  /// No description provided for @vseprTrigonalPyramidalDesc.
  ///
  /// In en, this message translates to:
  /// **'Three bonds + one lone pair. The lone pair occupies more space, compressing bond angles.'**
  String get vseprTrigonalPyramidalDesc;

  /// No description provided for @vseprBent104Desc.
  ///
  /// In en, this message translates to:
  /// **'Two bonds + two lone pairs. Two lone pairs provide maximum compression on the bonds.'**
  String get vseprBent104Desc;

  /// No description provided for @vseprOctahedralDesc.
  ///
  /// In en, this message translates to:
  /// **'Six bonds pointing to the faces of a regular cube. All bond angles are 90°.'**
  String get vseprOctahedralDesc;

  /// No description provided for @moleculeNameWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get moleculeNameWater;

  /// No description provided for @moleculeDescWater.
  ///
  /// In en, this message translates to:
  /// **'Two O–H bonds with two lone pairs on oxygen give water its bent shape and polarity.'**
  String get moleculeDescWater;

  /// No description provided for @moleculeNameCarbonDioxide.
  ///
  /// In en, this message translates to:
  /// **'Carbon dioxide'**
  String get moleculeNameCarbonDioxide;

  /// No description provided for @moleculeDescCarbonDioxide.
  ///
  /// In en, this message translates to:
  /// **'Two double bonds with no lone pairs on carbon. Linear and non-polar despite polar bonds.'**
  String get moleculeDescCarbonDioxide;

  /// No description provided for @moleculeNameMethane.
  ///
  /// In en, this message translates to:
  /// **'Methane'**
  String get moleculeNameMethane;

  /// No description provided for @moleculeDescMethane.
  ///
  /// In en, this message translates to:
  /// **'Four identical C–H bonds arranged tetrahedrally. A perfectly symmetrical non-polar molecule.'**
  String get moleculeDescMethane;

  /// No description provided for @moleculeNameAmmonia.
  ///
  /// In en, this message translates to:
  /// **'Ammonia'**
  String get moleculeNameAmmonia;

  /// No description provided for @moleculeDescAmmonia.
  ///
  /// In en, this message translates to:
  /// **'Three bonds and one lone pair compresses the bond angle to 107°.'**
  String get moleculeDescAmmonia;

  /// No description provided for @moleculeNameEthane.
  ///
  /// In en, this message translates to:
  /// **'Ethane'**
  String get moleculeNameEthane;

  /// No description provided for @moleculeDescEthane.
  ///
  /// In en, this message translates to:
  /// **'A simple alkane with a single carbon-carbon bond.'**
  String get moleculeDescEthane;

  /// No description provided for @moleculeNameEthanol.
  ///
  /// In en, this message translates to:
  /// **'Ethanol'**
  String get moleculeNameEthanol;

  /// No description provided for @moleculeDescEthanol.
  ///
  /// In en, this message translates to:
  /// **'The alcohol found in beverages, containing a hydroxyl group.'**
  String get moleculeDescEthanol;

  /// No description provided for @moleculeNameBenzene.
  ///
  /// In en, this message translates to:
  /// **'Benzene'**
  String get moleculeNameBenzene;

  /// No description provided for @moleculeDescBenzene.
  ///
  /// In en, this message translates to:
  /// **'A stable aromatic ring with delocalized pi electrons.'**
  String get moleculeDescBenzene;

  /// No description provided for @moleculeNameAspirin.
  ///
  /// In en, this message translates to:
  /// **'Aspirin'**
  String get moleculeNameAspirin;

  /// No description provided for @moleculeDescAspirin.
  ///
  /// In en, this message translates to:
  /// **'Acetylsalicylic acid, the common pain reliever.'**
  String get moleculeDescAspirin;

  /// No description provided for @moleculeViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'3D Molecule Viewer'**
  String get moleculeViewerTitle;

  /// No description provided for @vseprNameOctahedral.
  ///
  /// In en, this message translates to:
  /// **'Octahedral'**
  String get vseprNameOctahedral;

  /// No description provided for @vseprDescLinear.
  ///
  /// In en, this message translates to:
  /// **'Two bonding pairs, zero lone pairs. Atoms are arranged in a straight line for maximum separation.'**
  String get vseprDescLinear;

  /// No description provided for @vseprDescTrigonalPlanar.
  ///
  /// In en, this message translates to:
  /// **'Three bonds in a flat plane, equally spaced at 120° angles to minimize repulsion.'**
  String get vseprDescTrigonalPlanar;

  /// No description provided for @vseprDescBent120.
  ///
  /// In en, this message translates to:
  /// **'Two bonds and one lone pair. The lone pair pushes the bonds closer than 120°.'**
  String get vseprDescBent120;

  /// No description provided for @vseprDescTetrahedral.
  ///
  /// In en, this message translates to:
  /// **'Four bonds pointing to the corners of a regular tetrahedron. Highly symmetrical.'**
  String get vseprDescTetrahedral;

  /// No description provided for @vseprDescTrigonalPyramidal.
  ///
  /// In en, this message translates to:
  /// **'Three bonds + one lone pair. The lone pair occupies more space, compressing bond angles.'**
  String get vseprDescTrigonalPyramidal;

  /// No description provided for @vseprDescBent104.
  ///
  /// In en, this message translates to:
  /// **'Two bonds + two lone pairs. Two lone pairs provide maximum compression on the bonds.'**
  String get vseprDescBent104;

  /// No description provided for @vseprDescOctahedral.
  ///
  /// In en, this message translates to:
  /// **'Six bonds pointing to the faces of a regular cube. All bond angles are 90°.'**
  String get vseprDescOctahedral;

  /// No description provided for @vseprNameLinear.
  ///
  /// In en, this message translates to:
  /// **'Linear'**
  String get vseprNameLinear;

  /// No description provided for @vseprNameTrigonalPlanar.
  ///
  /// In en, this message translates to:
  /// **'Trigonal Planar'**
  String get vseprNameTrigonalPlanar;

  /// No description provided for @vseprNameBent120.
  ///
  /// In en, this message translates to:
  /// **'Bent (120°)'**
  String get vseprNameBent120;

  /// No description provided for @vseprNameTetrahedral.
  ///
  /// In en, this message translates to:
  /// **'Tetrahedral'**
  String get vseprNameTetrahedral;

  /// No description provided for @vseprNameTrigonalPyramidal.
  ///
  /// In en, this message translates to:
  /// **'Trigonal Pyramidal'**
  String get vseprNameTrigonalPyramidal;

  /// No description provided for @vseprNameBent104.
  ///
  /// In en, this message translates to:
  /// **'Bent (104.5°)'**
  String get vseprNameBent104;

  /// No description provided for @electrochemHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Electrochemistry'**
  String get electrochemHomeTitle;

  /// No description provided for @electrochemHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Lab Simulations'**
  String get electrochemHomeSubtitle;

  /// No description provided for @galvanicCellDesc.
  ///
  /// In en, this message translates to:
  /// **'Build voltaic cells, measure equilibrium potential E°cell'**
  String get galvanicCellDesc;

  /// No description provided for @electrolysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply voltage to drive non-spontaneous reactions'**
  String get electrolysisDesc;

  /// No description provided for @nernstEquationDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore how concentration and temperature affects Ecell'**
  String get nernstEquationDesc;

  /// No description provided for @electroplatingDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate mass deposition using Faraday\'s Law'**
  String get electroplatingDesc;

  /// No description provided for @upgradeToUnlockElectrolysis.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock Electrolysis!'**
  String get upgradeToUnlockElectrolysis;

  /// No description provided for @electrochemWalkthroughTitle.
  ///
  /// In en, this message translates to:
  /// **'Electrochemistry Lab'**
  String get electrochemWalkthroughTitle;

  /// No description provided for @electrochemWalkthroughDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore electrochemical cells, electrolysis, and electrochemical equations through interactive simulations.'**
  String get electrochemWalkthroughDesc;

  /// No description provided for @electrochemWalkthroughTip.
  ///
  /// In en, this message translates to:
  /// **'Electrochemistry is everywhere - from batteries to plating to corrosion!'**
  String get electrochemWalkthroughTip;

  /// No description provided for @galvanicCellWalkthroughDesc.
  ///
  /// In en, this message translates to:
  /// **'Build voltaic cells and measure equilibrium potential (E°cell).'**
  String get galvanicCellWalkthroughDesc;

  /// No description provided for @galvanicCellWalkthroughTip.
  ///
  /// In en, this message translates to:
  /// **'Galvanic cells convert chemical energy to electrical energy!'**
  String get galvanicCellWalkthroughTip;

  /// No description provided for @electrolysisWalkthroughTitle.
  ///
  /// In en, this message translates to:
  /// **'Electrolysis (Pro)'**
  String get electrolysisWalkthroughTitle;

  /// No description provided for @electrolysisWalkthroughDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply external voltage to drive non-spontaneous reactions.'**
  String get electrolysisWalkthroughDesc;

  /// No description provided for @electrolysisWalkthroughTip.
  ///
  /// In en, this message translates to:
  /// **'Electrolysis is used in electroplating and metal purification!'**
  String get electrolysisWalkthroughTip;

  /// No description provided for @nernstWalkthroughDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore how concentration and temperature affect cell potential.'**
  String get nernstWalkthroughDesc;

  /// No description provided for @nernstWalkthroughTip.
  ///
  /// In en, this message translates to:
  /// **'The Nernst equation relates cell potential to concentration!'**
  String get nernstWalkthroughTip;

  /// No description provided for @electroplatingWalkthroughDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate mass deposition using Faraday\'s Law.'**
  String get electroplatingWalkthroughDesc;

  /// No description provided for @electroplatingWalkthroughTip.
  ///
  /// In en, this message translates to:
  /// **'Faraday\'s Law connects electric charge to the amount of substance deposited!'**
  String get electroplatingWalkthroughTip;

  /// No description provided for @proFeaturesWalkthroughTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro Features'**
  String get proFeaturesWalkthroughTitle;

  /// No description provided for @proFeaturesWalkthroughDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock Electrolysis and remove ads with premium.'**
  String get proFeaturesWalkthroughDesc;

  /// No description provided for @proFeaturesWalkthroughTip.
  ///
  /// In en, this message translates to:
  /// **'Tap the stars icon to see subscription options!'**
  String get proFeaturesWalkthroughTip;

  /// No description provided for @galvanicCellBasics.
  ///
  /// In en, this message translates to:
  /// **'Galvanic Cell Basics'**
  String get galvanicCellBasics;

  /// No description provided for @galvanicCellHowItWorksDesc.
  ///
  /// In en, this message translates to:
  /// **'A galvanic (voltaic) cell converts chemical energy into electrical energy through spontaneous redox reactions. Electrons flow from the Anode to the Cathode.'**
  String get galvanicCellHowItWorksDesc;

  /// No description provided for @electromotiveForce.
  ///
  /// In en, this message translates to:
  /// **'Electromotive Force'**
  String get electromotiveForce;

  /// No description provided for @cellPotentialDesc.
  ///
  /// In en, this message translates to:
  /// **'The cell potential is calculated by the difference between the reduction potentials of the two electrodes.'**
  String get cellPotentialDesc;

  /// No description provided for @saltBridge.
  ///
  /// In en, this message translates to:
  /// **'Salt Bridge'**
  String get saltBridge;

  /// No description provided for @saltBridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'The salt bridge completes the circuit and maintains electrical neutrality by allowing ions to flow between the two half-cells.'**
  String get saltBridgeDesc;

  /// No description provided for @anodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Anode (−)'**
  String get anodeLabel;

  /// No description provided for @cathodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cathode (+)'**
  String get cathodeLabel;

  /// No description provided for @oxidationAnode.
  ///
  /// In en, this message translates to:
  /// **'Oxidation (Anode)'**
  String get oxidationAnode;

  /// No description provided for @reductionCathode.
  ///
  /// In en, this message translates to:
  /// **'Reduction (Cathode)'**
  String get reductionCathode;

  /// No description provided for @cellPotentialLabel.
  ///
  /// In en, this message translates to:
  /// **'E°cell (V)'**
  String get cellPotentialLabel;

  /// No description provided for @spontaneous.
  ///
  /// In en, this message translates to:
  /// **'SPONTANEOUS'**
  String get spontaneous;

  /// No description provided for @nonSpontaneous.
  ///
  /// In en, this message translates to:
  /// **'NON-SPONTANEOUS'**
  String get nonSpontaneous;

  /// No description provided for @nernstEquationTitle.
  ///
  /// In en, this message translates to:
  /// **'Nernst Equation'**
  String get nernstEquationTitle;

  /// No description provided for @nernstEquationExplorer.
  ///
  /// In en, this message translates to:
  /// **'Nernst Equation Explorer'**
  String get nernstEquationExplorer;

  /// No description provided for @nonStandardConditions.
  ///
  /// In en, this message translates to:
  /// **'Non-Standard Conditions'**
  String get nonStandardConditions;

  /// No description provided for @nonStandardConditionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard cell potentials (E°) are measured at 25°C and 1.0M concentration. The Nernst Equation calculates the actual potential under any other conditions.'**
  String get nonStandardConditionsDesc;

  /// No description provided for @theEquation.
  ///
  /// In en, this message translates to:
  /// **'The Equation'**
  String get theEquation;

  /// No description provided for @reactionQuotient.
  ///
  /// In en, this message translates to:
  /// **'Reaction Quotient (Q)'**
  String get reactionQuotient;

  /// No description provided for @reactionQuotientDesc.
  ///
  /// In en, this message translates to:
  /// **'Q is the ratio of product concentration to reactant concentration. If [Red] increases, Q increases and the cell potential (E) decreases.'**
  String get reactionQuotientDesc;

  /// No description provided for @temperatureK.
  ///
  /// In en, this message translates to:
  /// **'Temperature (K)'**
  String get temperatureK;

  /// No description provided for @oxConcentration.
  ///
  /// In en, this message translates to:
  /// **'[Ox] Concentration (M)'**
  String get oxConcentration;

  /// No description provided for @redConcentration.
  ///
  /// In en, this message translates to:
  /// **'[Red] Concentration (M)'**
  String get redConcentration;

  /// No description provided for @actualCellPotential.
  ///
  /// In en, this message translates to:
  /// **'ACTUAL CELL POTENTIAL (E)'**
  String get actualCellPotential;

  /// No description provided for @redOxRatio.
  ///
  /// In en, this message translates to:
  /// **'[Red]/[Ox] Ratio'**
  String get redOxRatio;

  /// No description provided for @voltageE.
  ///
  /// In en, this message translates to:
  /// **'E (V)'**
  String get voltageE;

  /// No description provided for @electrolysisLab.
  ///
  /// In en, this message translates to:
  /// **'Electrolysis Lab'**
  String get electrolysisLab;

  /// No description provided for @nonSpontaneousReactions.
  ///
  /// In en, this message translates to:
  /// **'Non-Spontaneous Reactions'**
  String get nonSpontaneousReactions;

  /// No description provided for @electrolysisHowDesc.
  ///
  /// In en, this message translates to:
  /// **'Electrolysis uses electrical energy to drive a chemical reaction that would not otherwise occur. It is the opposite of a galvanic cell.'**
  String get electrolysisHowDesc;

  /// No description provided for @decompositionOfNaCl.
  ///
  /// In en, this message translates to:
  /// **'Decomposition of NaCl'**
  String get decompositionOfNaCl;

  /// No description provided for @decompositionOfNaClDesc.
  ///
  /// In en, this message translates to:
  /// **'In aqueous NaCl, chloride ions are oxidized at the anode (forming Cl₂ gas) and water is reduced at the cathode (forming H₂ gas).'**
  String get decompositionOfNaClDesc;

  /// No description provided for @thresholdVoltageTitle.
  ///
  /// In en, this message translates to:
  /// **'Threshold Voltage'**
  String get thresholdVoltageTitle;

  /// No description provided for @thresholdVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Each electrolyte has a specific decomposition voltage (Vmin). If the applied voltage is lower than Vmin, no reaction occurs.'**
  String get thresholdVoltageDesc;

  /// No description provided for @upgradeToUnlockElectrolytes.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to PRO to unlock all electrolytes!'**
  String get upgradeToUnlockElectrolytes;

  /// No description provided for @upgradeToUnlockAllElectrolytes.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock all electrolytes!'**
  String get upgradeToUnlockAllElectrolytes;

  /// No description provided for @externalPowerSupply.
  ///
  /// In en, this message translates to:
  /// **'EXTERNAL POWER SUPPLY'**
  String get externalPowerSupply;

  /// No description provided for @minimumVoltageRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum voltage required: '**
  String get minimumVoltageRequired;

  /// No description provided for @electrolyteSolution.
  ///
  /// In en, this message translates to:
  /// **'ELECTROLYTE SOLUTION'**
  String get electrolyteSolution;

  /// No description provided for @electroplatingLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Electroplating Lab'**
  String get electroplatingLabTitle;

  /// No description provided for @electroplatingSecrets.
  ///
  /// In en, this message translates to:
  /// **'Electroplating Secrets'**
  String get electroplatingSecrets;

  /// No description provided for @whatIsElectroplating.
  ///
  /// In en, this message translates to:
  /// **'What is Electroplating?'**
  String get whatIsElectroplating;

  /// No description provided for @electroplatingProcessDesc.
  ///
  /// In en, this message translates to:
  /// **'A process of coating a base metal (like iron or brass) with a layer of a more precious metal (like gold or silver) via an electrolytic reaction.'**
  String get electroplatingProcessDesc;

  /// No description provided for @faradaysLawTitle.
  ///
  /// In en, this message translates to:
  /// **'Faraday\'s Law'**
  String get faradaysLawTitle;

  /// No description provided for @faradaysLawDesc.
  ///
  /// In en, this message translates to:
  /// **'The mass of the metal deposited is directly proportional to the amount of electric charge passed through the solution.'**
  String get faradaysLawDesc;

  /// No description provided for @molarMassAndValence.
  ///
  /// In en, this message translates to:
  /// **'Molar Mass & Valence'**
  String get molarMassAndValence;

  /// No description provided for @molarMassAndValenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Heavier metals with higher molar masses plate more mass per hour, while higher valence (n) values slow down the process because more electrons are needed per atom.'**
  String get molarMassAndValenceDesc;

  /// No description provided for @depositedMass.
  ///
  /// In en, this message translates to:
  /// **'DEPOSITED MASS'**
  String get depositedMass;

  /// No description provided for @elapsedTime.
  ///
  /// In en, this message translates to:
  /// **'ELAPSED TIME'**
  String get elapsedTime;

  /// No description provided for @dcCurrentSource.
  ///
  /// In en, this message translates to:
  /// **'D.C. CURRENT SOURCE'**
  String get dcCurrentSource;

  /// No description provided for @platingObjectKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get platingObjectKey;

  /// No description provided for @platingObjectSpoon.
  ///
  /// In en, this message translates to:
  /// **'Spoon'**
  String get platingObjectSpoon;

  /// No description provided for @platingObjectCoin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get platingObjectCoin;

  /// No description provided for @electrodeZinc.
  ///
  /// In en, this message translates to:
  /// **'Zinc'**
  String get electrodeZinc;

  /// No description provided for @electrodeIron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get electrodeIron;

  /// No description provided for @electrodeNickel.
  ///
  /// In en, this message translates to:
  /// **'Nickel'**
  String get electrodeNickel;

  /// No description provided for @electrodeLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get electrodeLead;

  /// No description provided for @electrodeCopper.
  ///
  /// In en, this message translates to:
  /// **'Copper'**
  String get electrodeCopper;

  /// No description provided for @electrodeSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get electrodeSilver;

  /// No description provided for @electrodeGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get electrodeGold;

  /// No description provided for @electrodePlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get electrodePlatinum;

  /// No description provided for @electrolyteNaCl.
  ///
  /// In en, this message translates to:
  /// **'Aqueous Sodium Chloride'**
  String get electrolyteNaCl;

  /// No description provided for @electrolyteCuSO4.
  ///
  /// In en, this message translates to:
  /// **'Copper (II) Sulfate'**
  String get electrolyteCuSO4;

  /// No description provided for @electrolyteWater.
  ///
  /// In en, this message translates to:
  /// **'Water (Dilute H₂SO₄)'**
  String get electrolyteWater;

  /// No description provided for @shmLab.
  ///
  /// In en, this message translates to:
  /// **'SHM'**
  String get shmLab;

  /// No description provided for @shmLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simple Harmonic Motion'**
  String get shmLabSubtitle;

  /// No description provided for @shmHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'SHM Lab'**
  String get shmHomeTitle;

  /// No description provided for @shmLessons.
  ///
  /// In en, this message translates to:
  /// **'LESSONS'**
  String get shmLessons;

  /// No description provided for @shmPractice.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE'**
  String get shmPractice;

  /// No description provided for @shmQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get shmQuiz;

  /// No description provided for @shmQuizSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge of SHM'**
  String get shmQuizSubtitle;

  /// No description provided for @shmSimulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get shmSimulation;

  /// No description provided for @shmSimulationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive spring-mass & pendulum'**
  String get shmSimulationSubtitle;

  /// No description provided for @shmComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get shmComplete;

  /// No description provided for @shmNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get shmNextQuestion;

  /// No description provided for @shmSeeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get shmSeeResults;

  /// No description provided for @shmQuizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get shmQuizResults;

  /// No description provided for @shmGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job! You have a solid understanding of SHM.'**
  String get shmGreatJob;

  /// No description provided for @shmKeepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing! Review the lessons and try again.'**
  String get shmKeepPracticing;

  /// No description provided for @shmRetryQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retry Quiz'**
  String get shmRetryQuiz;

  /// No description provided for @shmBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get shmBackToHome;

  /// Step progress indicator
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String shmStepOf(String current, String total);

  /// Question progress indicator
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String shmQuestionOf(String current, String total);

  /// Current score display
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String shmScoreLabel(String score);

  /// Percentage correct on quiz results
  ///
  /// In en, this message translates to:
  /// **'{percent}% Correct'**
  String shmPercentCorrect(String percent);

  /// No description provided for @shmLesson1Title.
  ///
  /// In en, this message translates to:
  /// **'What is SHM?'**
  String get shmLesson1Title;

  /// No description provided for @shmLesson1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Oscillations Around Us'**
  String get shmLesson1Subtitle;

  /// No description provided for @shmL1S1Title.
  ///
  /// In en, this message translates to:
  /// **'What is Simple Harmonic Motion?'**
  String get shmL1S1Title;

  /// No description provided for @shmL1S1Body.
  ///
  /// In en, this message translates to:
  /// **'Simple Harmonic Motion (SHM) is a type of periodic motion where the restoring force is directly proportional to the displacement from equilibrium. Think of a mass on a spring — when you pull it and let go, it bounces back and forth.'**
  String get shmL1S1Body;

  /// No description provided for @shmL1S2Title.
  ///
  /// In en, this message translates to:
  /// **'Key Characteristics'**
  String get shmL1S2Title;

  /// No description provided for @shmL1S2Body.
  ///
  /// In en, this message translates to:
  /// **'SHM has three key properties: (1) The motion repeats at regular intervals (periodic), (2) The acceleration is always directed toward the equilibrium position, (3) The acceleration is proportional to the displacement.'**
  String get shmL1S2Body;

  /// No description provided for @shmL1S3Title.
  ///
  /// In en, this message translates to:
  /// **'Restoring Force'**
  String get shmL1S3Title;

  /// No description provided for @shmL1S3Body.
  ///
  /// In en, this message translates to:
  /// **'The restoring force is what pulls the object back toward equilibrium. For a spring, this is given by Hooke\'s Law:'**
  String get shmL1S3Body;

  /// No description provided for @shmL1S3Formula.
  ///
  /// In en, this message translates to:
  /// **'F = -kx'**
  String get shmL1S3Formula;

  /// No description provided for @shmL1S4Title.
  ///
  /// In en, this message translates to:
  /// **'Amplitude & Equilibrium'**
  String get shmL1S4Title;

  /// No description provided for @shmL1S4Body.
  ///
  /// In en, this message translates to:
  /// **'The amplitude (A) is the maximum displacement from equilibrium. The equilibrium position is where the net force on the object is zero. The object oscillates between +A and -A.'**
  String get shmL1S4Body;

  /// No description provided for @shmLesson2Title.
  ///
  /// In en, this message translates to:
  /// **'Period & Frequency'**
  String get shmLesson2Title;

  /// No description provided for @shmLesson2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Timing the Oscillations'**
  String get shmLesson2Subtitle;

  /// No description provided for @shmL2S1Title.
  ///
  /// In en, this message translates to:
  /// **'What is Period?'**
  String get shmL2S1Title;

  /// No description provided for @shmL2S1Body.
  ///
  /// In en, this message translates to:
  /// **'The period (T) is the time taken for one complete oscillation. For example, if a pendulum swings back and forth in 2 seconds, its period is 2 s.'**
  String get shmL2S1Body;

  /// No description provided for @shmL2S2Title.
  ///
  /// In en, this message translates to:
  /// **'Period of a Spring'**
  String get shmL2S2Title;

  /// No description provided for @shmL2S2Body.
  ///
  /// In en, this message translates to:
  /// **'The period of a mass-spring system depends only on the mass (m) and the spring constant (k):'**
  String get shmL2S2Body;

  /// No description provided for @shmL2S2Formula.
  ///
  /// In en, this message translates to:
  /// **'T = 2π √(m/k)'**
  String get shmL2S2Formula;

  /// No description provided for @shmL2S3Title.
  ///
  /// In en, this message translates to:
  /// **'What is Frequency?'**
  String get shmL2S3Title;

  /// No description provided for @shmL2S3Body.
  ///
  /// In en, this message translates to:
  /// **'Frequency (f) is the number of oscillations per second. It is the reciprocal of the period: f = 1/T. The unit of frequency is the Hertz (Hz).'**
  String get shmL2S3Body;

  /// No description provided for @shmL2S4Title.
  ///
  /// In en, this message translates to:
  /// **'Angular Frequency'**
  String get shmL2S4Title;

  /// No description provided for @shmL2S4Body.
  ///
  /// In en, this message translates to:
  /// **'Angular frequency (ω) relates to the period and frequency through:'**
  String get shmL2S4Body;

  /// No description provided for @shmL2S4Formula.
  ///
  /// In en, this message translates to:
  /// **'ω = 2πf = 2π/T'**
  String get shmL2S4Formula;

  /// No description provided for @shmLesson3Title.
  ///
  /// In en, this message translates to:
  /// **'Energy in SHM'**
  String get shmLesson3Title;

  /// No description provided for @shmLesson3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Conservation of Energy'**
  String get shmLesson3Subtitle;

  /// No description provided for @shmL3S1Title.
  ///
  /// In en, this message translates to:
  /// **'Forms of Energy'**
  String get shmL3S1Title;

  /// No description provided for @shmL3S1Body.
  ///
  /// In en, this message translates to:
  /// **'In SHM, energy constantly transforms between kinetic energy (KE) and potential energy (PE). At equilibrium, KE is maximum and PE is zero. At the amplitude endpoints, KE is zero and PE is maximum.'**
  String get shmL3S1Body;

  /// No description provided for @shmL3S2Title.
  ///
  /// In en, this message translates to:
  /// **'Total Mechanical Energy'**
  String get shmL3S2Title;

  /// No description provided for @shmL3S2Body.
  ///
  /// In en, this message translates to:
  /// **'The total mechanical energy in SHM remains constant (ignoring friction). For a spring-mass system:'**
  String get shmL3S2Body;

  /// No description provided for @shmL3S2Formula.
  ///
  /// In en, this message translates to:
  /// **'E = ½kA²'**
  String get shmL3S2Formula;

  /// No description provided for @shmL3S3Title.
  ///
  /// In en, this message translates to:
  /// **'Energy at Any Point'**
  String get shmL3S3Title;

  /// No description provided for @shmL3S3Body.
  ///
  /// In en, this message translates to:
  /// **'At any displacement x from equilibrium: KE = ½k(A² − x²) and PE = ½kx². The sum KE + PE = ½kA² is always constant.'**
  String get shmL3S3Body;

  /// No description provided for @shmL3S4Title.
  ///
  /// In en, this message translates to:
  /// **'Velocity in SHM'**
  String get shmL3S4Title;

  /// No description provided for @shmL3S4Body.
  ///
  /// In en, this message translates to:
  /// **'The velocity of the oscillating object at any displacement x is given by:'**
  String get shmL3S4Body;

  /// No description provided for @shmL3S4Formula.
  ///
  /// In en, this message translates to:
  /// **'v = ±ω √(A² − x²)'**
  String get shmL3S4Formula;

  /// No description provided for @shmLesson4Title.
  ///
  /// In en, this message translates to:
  /// **'Real-World SHM'**
  String get shmLesson4Title;

  /// No description provided for @shmLesson4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'SHM in Everyday Life'**
  String get shmLesson4Subtitle;

  /// No description provided for @shmL4S1Title.
  ///
  /// In en, this message translates to:
  /// **'Pendulums'**
  String get shmL4S1Title;

  /// No description provided for @shmL4S1Body.
  ///
  /// In en, this message translates to:
  /// **'A simple pendulum approximates SHM for small angles (less than 15°). The period depends only on the length (L) and gravity (g): T = 2π√(L/g). This is why pendulum clocks work!'**
  String get shmL4S1Body;

  /// No description provided for @shmL4S2Title.
  ///
  /// In en, this message translates to:
  /// **'Waves & Sound'**
  String get shmL4S2Title;

  /// No description provided for @shmL4S2Body.
  ///
  /// In en, this message translates to:
  /// **'Sound waves are longitudinal waves where air molecules oscillate back and forth in SHM. Musical instruments like tuning forks and guitar strings also vibrate in SHM.'**
  String get shmL4S2Body;

  /// No description provided for @shmL4S3Title.
  ///
  /// In en, this message translates to:
  /// **'Molecular Vibrations'**
  String get shmL4S3Title;

  /// No description provided for @shmL4S3Body.
  ///
  /// In en, this message translates to:
  /// **'At the atomic level, atoms in a molecule vibrate about their equilibrium positions in SHM. This is why solids have thermal energy — atoms are constantly oscillating.'**
  String get shmL4S3Body;

  /// No description provided for @shmL4S4Title.
  ///
  /// In en, this message translates to:
  /// **'Engineering & Bridges'**
  String get shmL4S4Title;

  /// No description provided for @shmL4S4Body.
  ///
  /// In en, this message translates to:
  /// **'Engineers must account for SHM when designing buildings and bridges. The Tacoma Narrows Bridge collapse in 1940 is a famous example of resonance — when an external force matches the natural frequency of a structure.'**
  String get shmL4S4Body;

  /// No description provided for @shmQ1Question.
  ///
  /// In en, this message translates to:
  /// **'What is the restoring force in SHM proportional to?'**
  String get shmQ1Question;

  /// No description provided for @shmQ1Options.
  ///
  /// In en, this message translates to:
  /// **'[\"Velocity\",\"Displacement\",\"Time\",\"Mass\"]'**
  String get shmQ1Options;

  /// No description provided for @shmQ1CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get shmQ1CorrectIndex;

  /// No description provided for @shmQ1Explanation.
  ///
  /// In en, this message translates to:
  /// **'In SHM, the restoring force is directly proportional to the displacement from equilibrium (F = -kx).'**
  String get shmQ1Explanation;

  /// No description provided for @shmQ2Question.
  ///
  /// In en, this message translates to:
  /// **'What is the period of a mass-spring system with m = 4 kg and k = 100 N/m? (Assume π ≈ 3.14)'**
  String get shmQ2Question;

  /// No description provided for @shmQ2Options.
  ///
  /// In en, this message translates to:
  /// **'[\"0.63 s\",\"1.26 s\",\"2.51 s\",\"0.40 s\"]'**
  String get shmQ2Options;

  /// No description provided for @shmQ2CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get shmQ2CorrectIndex;

  /// No description provided for @shmQ2Explanation.
  ///
  /// In en, this message translates to:
  /// **'T = 2π√(m/k) = 2π√(4/100) = 2π × 0.2 = 1.26 seconds.'**
  String get shmQ2Explanation;

  /// No description provided for @shmQ3Question.
  ///
  /// In en, this message translates to:
  /// **'At which point in SHM is kinetic energy maximum?'**
  String get shmQ3Question;

  /// No description provided for @shmQ3Options.
  ///
  /// In en, this message translates to:
  /// **'[\"At the amplitude\",\"At equilibrium\",\"At the midpoint\",\"Kinetic energy is constant\"]'**
  String get shmQ3Options;

  /// No description provided for @shmQ3CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get shmQ3CorrectIndex;

  /// No description provided for @shmQ3Explanation.
  ///
  /// In en, this message translates to:
  /// **'Kinetic energy is maximum at the equilibrium position, where velocity is highest. At the endpoints, all energy is potential.'**
  String get shmQ3Explanation;

  /// No description provided for @shmQ4Question.
  ///
  /// In en, this message translates to:
  /// **'What happens to the period of a pendulum if the length is quadrupled?'**
  String get shmQ4Question;

  /// No description provided for @shmQ4Options.
  ///
  /// In en, this message translates to:
  /// **'[\"It doubles\",\"It halves\",\"It quadruples\",\"It stays the same\"]'**
  String get shmQ4Options;

  /// No description provided for @shmQ4CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get shmQ4CorrectIndex;

  /// No description provided for @shmQ4Explanation.
  ///
  /// In en, this message translates to:
  /// **'T ∝ √L, so if L increases by 4×, T increases by √4 = 2×.'**
  String get shmQ4Explanation;

  /// No description provided for @shmQ5Question.
  ///
  /// In en, this message translates to:
  /// **'The total mechanical energy in SHM is proportional to:'**
  String get shmQ5Question;

  /// No description provided for @shmQ5Options.
  ///
  /// In en, this message translates to:
  /// **'[\"The amplitude\",\"The square of the amplitude\",\"The mass\",\"The spring constant\"]'**
  String get shmQ5Options;

  /// No description provided for @shmQ5CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get shmQ5CorrectIndex;

  /// No description provided for @shmQ5Explanation.
  ///
  /// In en, this message translates to:
  /// **'Total energy E = ½kA², so it is proportional to the square of the amplitude (A²).'**
  String get shmQ5Explanation;

  /// No description provided for @shmSpringMode.
  ///
  /// In en, this message translates to:
  /// **'Spring-Mass'**
  String get shmSpringMode;

  /// No description provided for @shmPendulumMode.
  ///
  /// In en, this message translates to:
  /// **'Pendulum'**
  String get shmPendulumMode;

  /// No description provided for @shmVectors.
  ///
  /// In en, this message translates to:
  /// **'Vectors'**
  String get shmVectors;

  /// No description provided for @shmSpringConstant.
  ///
  /// In en, this message translates to:
  /// **'Spring Constant (k)'**
  String get shmSpringConstant;

  /// No description provided for @shmMassLabel.
  ///
  /// In en, this message translates to:
  /// **'Mass (m)'**
  String get shmMassLabel;

  /// No description provided for @shmAmplitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Amplitude (A)'**
  String get shmAmplitudeLabel;

  /// No description provided for @shmLength.
  ///
  /// In en, this message translates to:
  /// **'Length (L)'**
  String get shmLength;

  /// No description provided for @shmInitialAngle.
  ///
  /// In en, this message translates to:
  /// **'Initial Angle (θ₀)'**
  String get shmInitialAngle;

  /// No description provided for @shmPlanetMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get shmPlanetMoon;

  /// No description provided for @shmPlanetMars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get shmPlanetMars;

  /// No description provided for @shmPlanetEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get shmPlanetEarth;

  /// No description provided for @shmPlanetJupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get shmPlanetJupiter;

  /// No description provided for @shmStatusAdjustAmplitude.
  ///
  /// In en, this message translates to:
  /// **'Adjust amplitude to start'**
  String get shmStatusAdjustAmplitude;

  /// No description provided for @shmStatusAtEquilibrium.
  ///
  /// In en, this message translates to:
  /// **'At equilibrium — maximum speed, zero PE'**
  String get shmStatusAtEquilibrium;

  /// No description provided for @shmStatusAtMaxDisplacement.
  ///
  /// In en, this message translates to:
  /// **'At maximum displacement — zero speed, maximum PE'**
  String get shmStatusAtMaxDisplacement;

  /// No description provided for @shmStatusRestoringForce.
  ///
  /// In en, this message translates to:
  /// **'Restoring force pulling back toward equilibrium'**
  String get shmStatusRestoringForce;

  /// No description provided for @shmStatusMovingToEquilibrium.
  ///
  /// In en, this message translates to:
  /// **'Moving toward equilibrium — KE increasing'**
  String get shmStatusMovingToEquilibrium;

  /// No description provided for @shmStatusLargeAngle.
  ///
  /// In en, this message translates to:
  /// **'Large angle — approximation less accurate'**
  String get shmStatusLargeAngle;

  /// No description provided for @shmLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'SHM Lab - Simple Harmonic Motion'**
  String get shmLabTutorial;

  /// No description provided for @emInductionLab.
  ///
  /// In en, this message translates to:
  /// **'EM Induction'**
  String get emInductionLab;

  /// No description provided for @emInductionLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Electromagnetic Induction'**
  String get emInductionLabSubtitle;

  /// No description provided for @emInductionLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'EM Induction Lab - Electromagnetic Induction'**
  String get emInductionLabTutorial;

  /// No description provided for @emiAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Electromagnetic Induction'**
  String get emiAppTitle;

  /// No description provided for @emiHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Electromagnetic Induction'**
  String get emiHomeTitle;

  /// No description provided for @emiHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn. Explore. Understand.'**
  String get emiHomeSubtitle;

  /// No description provided for @emiLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get emiLessonLabel;

  /// No description provided for @emiSteps.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String emiSteps(String count);

  /// No description provided for @emiQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get emiQuiz;

  /// No description provided for @emiQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Your Knowledge'**
  String get emiQuizTitle;

  /// No description provided for @emiQuizSubtitle.
  ///
  /// In en, this message translates to:
  /// **'5 questions'**
  String get emiQuizSubtitle;

  /// No description provided for @emiSimLab.
  ///
  /// In en, this message translates to:
  /// **'Simulation Lab'**
  String get emiSimLab;

  /// No description provided for @emiSimTitle.
  ///
  /// In en, this message translates to:
  /// **'Open the Interactive Simulator'**
  String get emiSimTitle;

  /// No description provided for @emiSimSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drag the magnet, adjust controls, explore freely'**
  String get emiSimSubtitle;

  /// No description provided for @emiStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String emiStepOf(String current, String total);

  /// No description provided for @emiLessonBadge.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get emiLessonBadge;

  /// No description provided for @emiOpenSim.
  ///
  /// In en, this message translates to:
  /// **'Open Simulation'**
  String get emiOpenSim;

  /// No description provided for @emiBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get emiBack;

  /// No description provided for @emiDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get emiDone;

  /// No description provided for @emiNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get emiNext;

  /// No description provided for @emiQuizComplete.
  ///
  /// In en, this message translates to:
  /// **'Quiz Complete'**
  String get emiQuizComplete;

  /// No description provided for @emiGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get emiGreatJob;

  /// No description provided for @emiKeepLearning.
  ///
  /// In en, this message translates to:
  /// **'Keep Learning!'**
  String get emiKeepLearning;

  /// No description provided for @emiScoreCorrect.
  ///
  /// In en, this message translates to:
  /// **'{score} / {total} correct'**
  String emiScoreCorrect(String score, String total);

  /// No description provided for @emiPercentPassed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% — You passed!'**
  String emiPercentPassed(String percent);

  /// No description provided for @emiPercentTryAgain.
  ///
  /// In en, this message translates to:
  /// **'{percent}% — Try again to pass'**
  String emiPercentTryAgain(String percent);

  /// No description provided for @emiRetryQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retry Quiz'**
  String get emiRetryQuiz;

  /// No description provided for @emiBackToLessons.
  ///
  /// In en, this message translates to:
  /// **'Back to Lessons'**
  String get emiBackToLessons;

  /// No description provided for @emiQuestionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String emiQuestionOf(String current, String total);

  /// No description provided for @relativityLab.
  ///
  /// In en, this message translates to:
  /// **'RELATIVITY'**
  String get relativityLab;

  /// No description provided for @relativityLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Special Relativity'**
  String get relativityLabSubtitle;

  /// No description provided for @relativityLabTutorial.
  ///
  /// In en, this message translates to:
  /// **'Special Relativity Lab - Einstein\'s Theory'**
  String get relativityLabTutorial;

  /// No description provided for @emiCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get emiCorrect;

  /// No description provided for @emiIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get emiIncorrect;

  /// No description provided for @emiNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get emiNextQuestion;

  /// No description provided for @emiSeeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get emiSeeResults;

  /// No description provided for @emiSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get emiSpeed;

  /// No description provided for @emiField.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get emiField;

  /// No description provided for @emiTurns.
  ///
  /// In en, this message translates to:
  /// **'Turns'**
  String get emiTurns;

  /// No description provided for @emiEmf.
  ///
  /// In en, this message translates to:
  /// **'EMF'**
  String get emiEmf;

  /// No description provided for @emiFlux.
  ///
  /// In en, this message translates to:
  /// **'Flux Φ'**
  String get emiFlux;

  /// No description provided for @emiDFluxDt.
  ///
  /// In en, this message translates to:
  /// **'dΦ/dt'**
  String get emiDFluxDt;

  /// No description provided for @emiDir.
  ///
  /// In en, this message translates to:
  /// **'Dir'**
  String get emiDir;

  /// No description provided for @emiStatusExtremes.
  ///
  /// In en, this message translates to:
  /// **'At extremes — Velocity = 0, EMF = 0'**
  String get emiStatusExtremes;

  /// No description provided for @emiStatusCenter.
  ///
  /// In en, this message translates to:
  /// **'At coil center — Max velocity, Peak EMF'**
  String get emiStatusCenter;

  /// No description provided for @emiStatusEntering.
  ///
  /// In en, this message translates to:
  /// **'Entering coil — Flux increasing, EMF induced'**
  String get emiStatusEntering;

  /// No description provided for @emiStatusExiting.
  ///
  /// In en, this message translates to:
  /// **'Exiting coil — Flux decreasing, EMF reverses (Lenz)'**
  String get emiStatusExiting;

  /// No description provided for @emiFormulaEmf.
  ///
  /// In en, this message translates to:
  /// **'EMF = '**
  String get emiFormulaEmf;

  /// No description provided for @emiFormula.
  ///
  /// In en, this message translates to:
  /// **'-N × ΔΦ/Δt'**
  String get emiFormula;

  /// No description provided for @emiFormulaEquals.
  ///
  /// In en, this message translates to:
  /// **'= '**
  String get emiFormulaEquals;

  /// No description provided for @emiPeak.
  ///
  /// In en, this message translates to:
  /// **'PEAK'**
  String get emiPeak;

  /// No description provided for @emiZero.
  ///
  /// In en, this message translates to:
  /// **'ZERO'**
  String get emiZero;

  /// No description provided for @emiReversal.
  ///
  /// In en, this message translates to:
  /// **'REVERSAL'**
  String get emiReversal;

  /// No description provided for @emiEmfReadout.
  ///
  /// In en, this message translates to:
  /// **'EMF: {value} V'**
  String emiEmfReadout(String value);

  /// No description provided for @emiFluxReadout.
  ///
  /// In en, this message translates to:
  /// **'Φ: {value} Wb'**
  String emiFluxReadout(String value);

  /// No description provided for @emiEmfLegend.
  ///
  /// In en, this message translates to:
  /// **'EMF'**
  String get emiEmfLegend;

  /// No description provided for @emiFluxLegend.
  ///
  /// In en, this message translates to:
  /// **'FLUX'**
  String get emiFluxLegend;

  /// No description provided for @emiL1Title.
  ///
  /// In en, this message translates to:
  /// **'What is Electromagnetic Induction?'**
  String get emiL1Title;

  /// No description provided for @emiL1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Faraday\'s 1831 discovery that changed the world'**
  String get emiL1Subtitle;

  /// No description provided for @emiL1S1Title.
  ///
  /// In en, this message translates to:
  /// **'The Discovery'**
  String get emiL1S1Title;

  /// No description provided for @emiL1S1Body.
  ///
  /// In en, this message translates to:
  /// **'In 1831, Michael Faraday discovered that a CHANGING magnetic field creates an electric current in a nearby wire.\n\nBefore Faraday, scientists knew electricity and magnetism were related. He showed exactly how they connect.'**
  String get emiL1S1Body;

  /// No description provided for @emiL1S2Title.
  ///
  /// In en, this message translates to:
  /// **'The Water Pipe Analogy'**
  String get emiL1S2Title;

  /// No description provided for @emiL1S2Body.
  ///
  /// In en, this message translates to:
  /// **'Imagine a pipe full of water. If you push a plunger through, the water moves.\n\nA magnet moving through a coil is like that plunger — it \"pushes\" the electrons in the wire, creating an electric current.\n\nKey insight: the magnet must be MOVING. A stationary magnet does nothing.'**
  String get emiL1S2Body;

  /// No description provided for @emiL1S3Title.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll See'**
  String get emiL1S3Title;

  /// No description provided for @emiL1S3Body.
  ///
  /// In en, this message translates to:
  /// **'When the magnet enters the coil, electrons start flowing.\n\nWhen the magnet is at the center, moving fastest — the current is strongest.\n\nWhen the magnet exits, current flows the opposite direction.\n\nThis alternating current (AC) is what powers your home!'**
  String get emiL1S3Body;

  /// No description provided for @emiL1S4Title.
  ///
  /// In en, this message translates to:
  /// **'Try It Yourself'**
  String get emiL1S4Title;

  /// No description provided for @emiL1S4Body.
  ///
  /// In en, this message translates to:
  /// **'Open the simulation. Watch what happens to the EMF as you move the magnet:\n\n1. Slowly move the magnet through the coil\n2. Watch the green EMF waveform appear\n3. Try different speeds — what changes?'**
  String get emiL1S4Body;

  /// No description provided for @emiL2Title.
  ///
  /// In en, this message translates to:
  /// **'Faraday\'s Law'**
  String get emiL2Title;

  /// No description provided for @emiL2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'EMF = -N × ΔΦ/Δt'**
  String get emiL2Subtitle;

  /// No description provided for @emiL2S1Title.
  ///
  /// In en, this message translates to:
  /// **'The Formula'**
  String get emiL2S1Title;

  /// No description provided for @emiL2S1Body.
  ///
  /// In en, this message translates to:
  /// **'Faraday\'s Law is the mathematical heart of induction:\n\nEMF = -N × ΔΦ/Δt\n\nLet\'s break down each piece.'**
  String get emiL2S1Body;

  /// No description provided for @emiL2S1Formula.
  ///
  /// In en, this message translates to:
  /// **'EMF = −N × ΔΦ/Δt'**
  String get emiL2S1Formula;

  /// No description provided for @emiL2S2Title.
  ///
  /// In en, this message translates to:
  /// **'N — Number of Turns'**
  String get emiL2S2Title;

  /// No description provided for @emiL2S2Body.
  ///
  /// In en, this message translates to:
  /// **'N = number of wire loops (turns) in the coil.\n\nThink of it like fishing nets: more loops = more wires cutting through the magnetic field = more induced EMF.\n\nDoubling N doubles the EMF. This is why real generators use coils with hundreds of turns!'**
  String get emiL2S2Body;

  /// No description provided for @emiL2S3Title.
  ///
  /// In en, this message translates to:
  /// **'ΔΦ — Change in Flux'**
  String get emiL2S3Title;

  /// No description provided for @emiL2S3Body.
  ///
  /// In en, this message translates to:
  /// **'Φ (Phi) = magnetic flux = the amount of magnetic field passing through the coil.\n\nΔΦ = the CHANGE in flux. When the magnet moves closer, flux increases. When it moves away, flux decreases.\n\nBigger magnets or stronger fields = bigger ΔΦ = bigger EMF.'**
  String get emiL2S3Body;

  /// No description provided for @emiL2S4Title.
  ///
  /// In en, this message translates to:
  /// **'Δt — Time Interval'**
  String get emiL2S4Title;

  /// No description provided for @emiL2S4Body.
  ///
  /// In en, this message translates to:
  /// **'Δt = the time over which the flux changes.\n\nFaster motion = smaller Δt = larger EMF.\n\nThis is why pushing the magnet through quickly gives a bigger voltage spike than moving it slowly.'**
  String get emiL2S4Body;

  /// No description provided for @emiL2S5Title.
  ///
  /// In en, this message translates to:
  /// **'Try It Yourself'**
  String get emiL2S5Title;

  /// No description provided for @emiL2S5Body.
  ///
  /// In en, this message translates to:
  /// **'Open the simulation and test each variable:\n\n1. Adjust the \"Turns\" slider — does EMF scale with N?\n2. Adjust \"Field Strength\" — stronger magnet = more flux?\n3. Adjust \"Speed\" — faster motion = bigger EMF?\n\nWatch the formula panel update LIVE with your changes!'**
  String get emiL2S5Body;

  /// No description provided for @emiL3Title.
  ///
  /// In en, this message translates to:
  /// **'Lenz\'s Law'**
  String get emiL3Title;

  /// No description provided for @emiL3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Why the minus sign? The coil fights back'**
  String get emiL3Subtitle;

  /// No description provided for @emiL3S1Title.
  ///
  /// In en, this message translates to:
  /// **'The Minus Sign'**
  String get emiL3S1Title;

  /// No description provided for @emiL3S1Body.
  ///
  /// In en, this message translates to:
  /// **'The minus sign in Faraday\'s Law is NOT just a mathematical quirk — it\'s a physical law (Lenz\'s Law).\n\nIt means: the induced current creates a magnetic field that OPPOSES the change that created it.\n\nNature hates change! The coil \"fights back\" against the magnet\'s motion.'**
  String get emiL3S1Body;

  /// No description provided for @emiL3S1Formula.
  ///
  /// In en, this message translates to:
  /// **'EMF = −N × ΔΦ/Δt'**
  String get emiL3S1Formula;

  /// No description provided for @emiL3S2Title.
  ///
  /// In en, this message translates to:
  /// **'Approaching Magnet'**
  String get emiL3S2Title;

  /// No description provided for @emiL3S2Body.
  ///
  /// In en, this message translates to:
  /// **'When the magnet\'s NORTH pole approaches from above:\n\n1. Flux through the coil INCREASES\n2. The induced current creates a NORTH pole facing UP\n3. This REPELS the approaching magnet\n\nThe coil says: \"Stop getting closer!\" ↑'**
  String get emiL3S2Body;

  /// No description provided for @emiL3S3Title.
  ///
  /// In en, this message translates to:
  /// **'Retreating Magnet'**
  String get emiL3S3Title;

  /// No description provided for @emiL3S3Body.
  ///
  /// In en, this message translates to:
  /// **'When the magnet moves AWAY:\n\n1. Flux through the coil DECREASES\n2. The induced current creates a SOUTH pole facing UP\n3. This ATTRACTS the retreating magnet\n\nThe coil says: \"Don\'t leave!\" ←'**
  String get emiL3S3Body;

  /// No description provided for @emiL3S4Title.
  ///
  /// In en, this message translates to:
  /// **'Clockwise vs Counter-Clockwise'**
  String get emiL3S4Title;

  /// No description provided for @emiL3S4Body.
  ///
  /// In en, this message translates to:
  /// **'The direction of the induced current tells you what the coil is doing:\n\nRED glow (CW) = coil creating a north pole (repelling the approaching N pole)\nBLUE glow (CCW) = coil creating a south pole (attracting the retreating N pole)\n\nThis is energy conservation in action — you have to DO WORK to move the magnet against this opposing force.'**
  String get emiL3S4Body;

  /// No description provided for @emiL3S5Title.
  ///
  /// In en, this message translates to:
  /// **'Try It Yourself'**
  String get emiL3S5Title;

  /// No description provided for @emiL3S5Body.
  ///
  /// In en, this message translates to:
  /// **'Open the simulation and focus on the coil color:\n\n1. Watch the glow — red when EMF is positive, blue when negative\n2. Can you predict which color appears when the magnet enters vs exits?\n3. Drag the magnet manually and feel the opposition (watch the arrows!)'**
  String get emiL3S5Body;

  /// No description provided for @emiL4Title.
  ///
  /// In en, this message translates to:
  /// **'Real-World Applications'**
  String get emiL4Title;

  /// No description provided for @emiL4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Induction is everywhere around you'**
  String get emiL4Subtitle;

  /// No description provided for @emiL4S1Title.
  ///
  /// In en, this message translates to:
  /// **'Electric Generators'**
  String get emiL4S1Title;

  /// No description provided for @emiL4S1Body.
  ///
  /// In en, this message translates to:
  /// **'Every power plant uses electromagnetic induction!\n\nTurbines (steam, water, or wind) spin magnets inside coils of wire, generating the electricity that powers our homes.\n\nThe only difference from our simulation: the magnet ROTATES instead of moving up and down.\n\nOne spinning magnet = a continuous AC waveform!'**
  String get emiL4S1Body;

  /// No description provided for @emiL4S2Title.
  ///
  /// In en, this message translates to:
  /// **'Wireless Charging'**
  String get emiL4S2Title;

  /// No description provided for @emiL4S2Body.
  ///
  /// In en, this message translates to:
  /// **'Your phone\'s wireless charger is a real-world Faraday\'s Law demo!\n\nThe charger contains a coil that creates a rapidly changing magnetic field.\nYour phone contains another coil. The changing field induces a current in it.\n\nThat current charges your battery — no wires needed!\n\nFaraday\'s Law, in your pocket, every day.'**
  String get emiL4S2Body;

  /// No description provided for @emiL4S3Title.
  ///
  /// In en, this message translates to:
  /// **'Induction Cooktops'**
  String get emiL4S3Title;

  /// No description provided for @emiL4S3Body.
  ///
  /// In en, this message translates to:
  /// **'Induction cooktops use changing magnetic fields to heat pans DIRECTLY.\n\nA coil under the glass creates a high-frequency changing field.\nThis induces \"eddy currents\" in the metal pan.\nThe resistance of the pan to these currents creates heat.\n\nNo flame. No glowing element. Just pure induction heating your food!'**
  String get emiL4S3Body;

  /// No description provided for @emiL4S4Title.
  ///
  /// In en, this message translates to:
  /// **'Try It Yourself'**
  String get emiL4S4Title;

  /// No description provided for @emiL4S4Body.
  ///
  /// In en, this message translates to:
  /// **'Open the simulation one final time. Now that you understand the full physics:\n\n1. Can you explain exactly why the EMF peaks at the center?\n2. Why does increasing turns increase the EMF?\n3. What does the minus sign physically mean?\n\nEverything you see in the sim applies directly to real-world technology!'**
  String get emiL4S4Body;

  /// No description provided for @emiQ1Question.
  ///
  /// In en, this message translates to:
  /// **'What did Michael Faraday discover in 1831?'**
  String get emiQ1Question;

  /// No description provided for @emiQ1Options.
  ///
  /// In en, this message translates to:
  /// **'[\"That electricity flows through copper wires\",\"That a changing magnetic field induces an electric current\",\"That magnets attract iron\",\"That light is an electromagnetic wave\"]'**
  String get emiQ1Options;

  /// No description provided for @emiQ1CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get emiQ1CorrectIndex;

  /// No description provided for @emiQ1Explanation.
  ///
  /// In en, this message translates to:
  /// **'Faraday discovered electromagnetic induction — a changing magnetic field creates (induces) an electric current in a nearby conductor.'**
  String get emiQ1Explanation;

  /// No description provided for @emiQ2Question.
  ///
  /// In en, this message translates to:
  /// **'In Faraday\'s Law, what does the variable N represent?'**
  String get emiQ2Question;

  /// No description provided for @emiQ2Options.
  ///
  /// In en, this message translates to:
  /// **'[\"The strength of the magnet\",\"The number of turns in the coil\",\"The speed of the magnet\",\"The voltage output\"]'**
  String get emiQ2Options;

  /// No description provided for @emiQ2CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get emiQ2CorrectIndex;

  /// No description provided for @emiQ2Explanation.
  ///
  /// In en, this message translates to:
  /// **'N is the number of wire loops (turns) in the coil. More turns = more EMF, because more wires intersect the changing magnetic field.'**
  String get emiQ2Explanation;

  /// No description provided for @emiQ3Question.
  ///
  /// In en, this message translates to:
  /// **'According to Lenz\'s Law, what does the minus sign in EMF = −N×ΔΦ/Δt mean?'**
  String get emiQ3Question;

  /// No description provided for @emiQ3Options.
  ///
  /// In en, this message translates to:
  /// **'[\"The EMF is always negative\",\"Energy is lost to heat\",\"The induced current opposes the change in flux\",\"The formula is incomplete\"]'**
  String get emiQ3Options;

  /// No description provided for @emiQ3CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get emiQ3CorrectIndex;

  /// No description provided for @emiQ3Explanation.
  ///
  /// In en, this message translates to:
  /// **'The minus sign represents Lenz\'s Law: the induced current creates a magnetic field that OPPOSES the change that produced it. The coil \"fights back.\"'**
  String get emiQ3Explanation;

  /// No description provided for @emiQ4Question.
  ///
  /// In en, this message translates to:
  /// **'When is the induced EMF maximum in the simulation?'**
  String get emiQ4Question;

  /// No description provided for @emiQ4Options.
  ///
  /// In en, this message translates to:
  /// **'[\"When the magnet is at the top of its motion\",\"When the magnet is at the bottom of its motion\",\"When the magnet is at the coil center, moving fastest\",\"When the magnet is stationary at any position\"]'**
  String get emiQ4Options;

  /// No description provided for @emiQ4CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get emiQ4CorrectIndex;

  /// No description provided for @emiQ4Explanation.
  ///
  /// In en, this message translates to:
  /// **'EMF is proportional to ΔΦ/Δt — the RATE of change of flux. At the center, the magnet is moving fastest, so flux changes fastest, giving peak EMF.'**
  String get emiQ4Explanation;

  /// No description provided for @emiQ5Question.
  ///
  /// In en, this message translates to:
  /// **'Which of these is NOT an application of electromagnetic induction?'**
  String get emiQ5Question;

  /// No description provided for @emiQ5Options.
  ///
  /// In en, this message translates to:
  /// **'[\"Electric power generators\",\"Wireless phone charging\",\"A standard flashlight battery\",\"Induction cooktops\"]'**
  String get emiQ5Options;

  /// No description provided for @emiQ5CorrectIndex.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get emiQ5CorrectIndex;

  /// No description provided for @emiQ5Explanation.
  ///
  /// In en, this message translates to:
  /// **'Batteries use chemical reactions to produce electricity, not electromagnetic induction. Generators, wireless chargers, and induction cooktops all use Faraday\'s Law directly.'**
  String get emiQ5Explanation;
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
