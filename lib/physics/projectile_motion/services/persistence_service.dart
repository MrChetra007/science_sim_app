import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/simulation_state.dart';

class PersistenceService {
  static const String _key = 'simulation_settings';

  static Future<void> saveSettings(SimulationState state) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'angle': state.angle,
      'speed': state.initialSpeed,
      'height': state.initialHeight,
      'gravity': state.gravity,
      'gravityId': state.selectedGravityId,
      'objectId': state.selectedObjectId,
      'airResistance': state.airResistance,
      'slowMotion': state.slowMotion,
    };
    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
