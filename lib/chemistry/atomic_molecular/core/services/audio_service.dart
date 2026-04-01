import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playElectronJump() async {
    try {
      await _player.play(AssetSource('sounds/electron_jump.mp3'));
    } catch (_) {
      // Asset might be missing in early dev
    }
  }

  static Future<void> playMoleculeSnap() async {
    try {
      await _player.play(AssetSource('sounds/snap.mp3'));
    } catch (_) {
      // Asset might be missing
    }
  }

  static Future<void> playOrbitalSelect() async {
    try {
      await _player.play(AssetSource('sounds/select.mp3'));
    } catch (_) {
      // Asset might be missing
    }
  }
}
