import 'package:flutter/material.dart';
import '../lesson_data.dart';
import '../../../../l10n/generated/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  int _score = 0;
  bool _quizComplete = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quizQuestions = getQuizQuestions(l10n);

    if (_quizComplete) return _buildResults(l10n);

    final question = quizQuestions[_currentQuestion];
    final total = quizQuestions.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.shmQuiz, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.shmQuestionOf('${_currentQuestion + 1}', '$total'),
                  style: const TextStyle(color: Color(0xFF42A5F5), fontSize: 14),
                ),
                const Spacer(),
                Text(
                  l10n.shmScoreLabel('$_score'),
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentQuestion + 1) / total,
                backgroundColor: const Color(0xFF2A2A4A),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF42A5F5)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              question.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ...question.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final option = entry.value;
              Color? bgColor;
              Color borderColor;
              Color textColor = Colors.white;

              if (_showExplanation) {
                if (idx == question.correctIndex) {
                  bgColor = const Color(0xFF1A3A1A);
                  borderColor = Colors.green;
                  textColor = Colors.green;
                } else if (idx == _selectedAnswer) {
                  bgColor = const Color(0xFF3A1A1A);
                  borderColor = Colors.red;
                  textColor = Colors.red;
                } else {
                  bgColor = const Color(0xFF1A1A2E);
                  borderColor = const Color(0xFF2A2A4A);
                  textColor = Colors.grey;
                }
              } else {
                bgColor = idx == _selectedAnswer
                    ? const Color(0xFF2A2A5A)
                    : const Color(0xFF1A1A2E);
                borderColor = idx == _selectedAnswer
                    ? const Color(0xFF42A5F5)
                    : const Color(0xFF2A2A4A);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: _showExplanation
                      ? null
                      : () {
                          setState(() {
                            _selectedAnswer = idx;
                            _showExplanation = true;
                            if (idx == question.correctIndex) {
                              _score++;
                            }
                          });
                        },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      '${String.fromCharCode(65 + idx)}. $option',
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                  ),
                ),
              );
            }),
            if (_showExplanation) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A2A4A)),
                ),
                child: Text(
                  quizQuestions[_currentQuestion].explanation,
                  style: const TextStyle(color: Color(0xFFB0B0C0), fontSize: 13, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentQuestion < total - 1) {
                      setState(() {
                        _currentQuestion++;
                        _selectedAnswer = null;
                        _showExplanation = false;
                      });
                    } else {
                      setState(() => _quizComplete = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42A5F5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    _currentQuestion < total - 1 ? l10n.shmNextQuestion : l10n.shmSeeResults,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n) {
    final total = 5;
    final percentage = (_score / total * 100).round();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.shmQuizResults, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                percentage >= 80 ? '\u{1F389}' : '\u{1F4AA}',
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 24),
              Text(
                '$_score / $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.shmPercentCorrect('$percentage'),
                style: TextStyle(
                  color: percentage >= 80 ? Colors.green : Colors.orange,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                percentage >= 80 ? l10n.shmGreatJob : l10n.shmKeepPracticing,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB0B0C0), fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentQuestion = 0;
                    _selectedAnswer = null;
                    _showExplanation = false;
                    _score = 0;
                    _quizComplete = false;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: Text(l10n.shmRetryQuiz),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.shmBackToHome,
                  style: const TextStyle(color: Color(0xFF42A5F5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
