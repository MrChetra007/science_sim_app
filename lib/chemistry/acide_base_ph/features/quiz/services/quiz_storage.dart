import 'package:shared_preferences/shared_preferences.dart';

class QuizStorage {
  static const _key = 'best_quiz_score';

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final best = await getBestScore();
    if (score > best) {
      await prefs.setInt(_key, score);
    }
  }
}
