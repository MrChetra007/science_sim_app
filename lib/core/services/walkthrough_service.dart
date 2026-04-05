import 'package:shared_preferences/shared_preferences.dart';

class WalkthroughService {
  static const String _keyGlobalOnboarding = 'walkthrough_global_done';
  static const String _keyNewtonLab = 'walkthrough_newton_lab_done';
  static const String _keyOhmLab = 'walkthrough_ohm_lab_done';
  static const String _keyProjectileMotion = 'walkthrough_projectile_motion_done';
  static const String _keyAcLab = 'walkthrough_ac_lab_done';
  static const String _keyWaveLab = 'walkthrough_wave_lab_done';
  static const String _keyThermoLab = 'walkthrough_thermo_lab_done';
  static const String _keyPhLab = 'walkthrough_ph_lab_done';
  static const String _keyAtomicMolecular = 'walkthrough_atomic_molecular_done';
  static const String _keyElectrochemistry = 'walkthrough_electrochemistry_done';

  static Future<bool> isGlobalOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyGlobalOnboarding) ?? false;
  }

  static Future<void> markGlobalOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyGlobalOnboarding, true);
  }

  static Future<bool> isLabOnboardingShown(String labKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(labKey) ?? false;
  }

  static Future<void> markLabOnboardingShown(String labKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(labKey, true);
  }

  static Future<void> resetLabWalkthrough(String labKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(labKey);
  }

  static Future<void> resetAllWalkthroughs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGlobalOnboarding);
    await prefs.remove(_keyNewtonLab);
    await prefs.remove(_keyOhmLab);
    await prefs.remove(_keyProjectileMotion);
    await prefs.remove(_keyAcLab);
    await prefs.remove(_keyWaveLab);
    await prefs.remove(_keyThermoLab);
    await prefs.remove(_keyPhLab);
    await prefs.remove(_keyAtomicMolecular);
    await prefs.remove(_keyElectrochemistry);
  }

  static String get labKeys => _keyNewtonLab;

  static const String keyNewtonLab = _keyNewtonLab;
  static const String keyOhmLab = _keyOhmLab;
  static const String keyProjectileMotion = _keyProjectileMotion;
  static const String keyAcLab = _keyAcLab;
  static const String keyWaveLab = _keyWaveLab;
  static const String keyThermoLab = _keyThermoLab;
  static const String keyPhLab = _keyPhLab;
  static const String keyAtomicMolecular = _keyAtomicMolecular;
  static const String keyElectrochemistry = _keyElectrochemistry;
}
