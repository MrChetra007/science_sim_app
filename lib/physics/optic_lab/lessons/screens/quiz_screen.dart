import 'package:flutter/material.dart';
import '../lesson_data.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../theme.dart';

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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(l10n.opticQuiz,
            style: const TextStyle(color: AppColors.text)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
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
                  l10n.opticQuestionOf('${_currentQuestion + 1}', '$total'),
                  style: const TextStyle(color: AppColors.accent, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  l10n.opticScoreLabel('$_score'),
                  style: const TextStyle(color: AppColors.success, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentQuestion + 1) / total,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              question.question,
              style: const TextStyle(
                color: AppColors.text,
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
              Color textColor = AppColors.text;

              if (_showExplanation) {
                if (idx == question.correctIndex) {
                  bgColor = AppColors.success.withValues(alpha: 0.12);
                  borderColor = AppColors.success;
                  textColor = AppColors.success;
                } else if (idx == _selectedAnswer) {
                  bgColor = AppColors.danger.withValues(alpha: 0.12);
                  borderColor = AppColors.danger;
                  textColor = AppColors.danger;
                } else {
                  bgColor = AppColors.card;
                  borderColor = AppColors.border;
                  textColor = AppColors.dim;
                }
              } else {
                bgColor =
                    idx == _selectedAnswer ? AppColors.hover : AppColors.card;
                borderColor = idx == _selectedAnswer
                    ? AppColors.accent
                    : AppColors.border;
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
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  quizQuestions[_currentQuestion].explanation,
                  style: const TextStyle(
                      color: AppColors.dim, fontSize: 13, height: 1.4),
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
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    _currentQuestion < total - 1
                        ? l10n.opticNextQuestion
                        : l10n.opticSeeResults,
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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(l10n.opticQuizResults,
            style: const TextStyle(color: AppColors.text)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
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
                  color: AppColors.text,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.opticPercentCorrect('$percentage'),
                style: TextStyle(
                  color:
                      percentage >= 80 ? AppColors.success : AppColors.warning,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                percentage >= 80 ? l10n.opticGreatJob : l10n.opticKeepPracticing,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.dim, fontSize: 15, height: 1.4),
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
                label: Text(l10n.opticRetryQuiz),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.opticBackToHome,
                  style: const TextStyle(color: AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}