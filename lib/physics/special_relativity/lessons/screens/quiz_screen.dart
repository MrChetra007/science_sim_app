import 'package:flutter/material.dart';
import '../lesson_data.dart';
import '../models/lesson.dart';
import 'package:science_lab/l10n/generated/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _answerSubmitted = false;
  int _score = 0;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    _questions = buildQuizQuestions(AppLocalizations.of(context)!);
  }

  void _submitAnswer(int index) {
    if (_answerSubmitted) return;

    setState(() {
      _selectedAnswerIndex = index;
      _answerSubmitted = true;
      if (index == _questions[_currentQuestionIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _answerSubmitted = false;
      } else {
        _quizFinished = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswerIndex = null;
      _answerSubmitted = false;
      _score = 0;
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0a0a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.relQuizTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _quizFinished ? _buildResultsView() : _buildQuizView(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      key: ValueKey<int>(_currentQuestionIndex),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress text and bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.relQuestionOf((_currentQuestionIndex + 1).toString(), _questions.length.toString()),
              style: const TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Text(
              AppLocalizations.of(context)!.relScore(_score.toString()),
              style: const TextStyle(color: Color(0xff4fc3f7), fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xff15152a),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff4fc3f7)),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 24),

        // Question card
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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

                // Options list
                ...List.generate(question.options.length, (index) {
                  final optionText = question.options[index];
                  final isSelected = _selectedAnswerIndex == index;
                  final isCorrect = question.correctIndex == index;

                  Color itemColor = const Color(0xff15152a);
                  Color borderColor = const Color(0xff4fc3f7).withOpacity(0.15);
                  Widget trailingIcon = const SizedBox.shrink();

                  if (_answerSubmitted) {
                    if (isCorrect) {
                      itemColor = const Color(0xff092a10);
                      borderColor = const Color(0xff00ff41).withOpacity(0.5);
                      trailingIcon = const Icon(Icons.check_circle, color: Color(0xff00ff41), size: 20);
                    } else if (isSelected) {
                      itemColor = const Color(0xff2d0d0d);
                      borderColor = const Color(0xffff4444).withOpacity(0.5);
                      trailingIcon = const Icon(Icons.cancel, color: Color(0xffff4444), size: 20);
                    }
                  } else {
                    if (isSelected) {
                      borderColor = const Color(0xff4fc3f7);
                      itemColor = const Color(0xff1a2636);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () => _submitAnswer(index),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: itemColor,
                          border: Border.all(color: borderColor, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                optionText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            trailingIcon,
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Explanation Section
                if (_answerSubmitted) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff0e1e2d),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xff4fc3f7).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _selectedAnswerIndex == question.correctIndex
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              color: const Color(0xff4fc3f7),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.relExplanation,
                              style: TextStyle(
                                color: Color(0xff4fc3f7),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          question.explanation,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Navigation button
        if (_answerSubmitted)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4fc3f7),
                foregroundColor: const Color(0xff0a0a1a),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentQuestionIndex < _questions.length - 1 ? AppLocalizations.of(context)!.relNextQuestion : AppLocalizations.of(context)!.relSeeResults,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultsView() {
    final percent = (_score / _questions.length) * 100;
    String feedback = AppLocalizations.of(context)!.relKeepLearning;
    String details = AppLocalizations.of(context)!.relKeepLearningDetails;
    IconData icon = Icons.psychology;
    Color color = const Color(0xffff9800);

    if (percent == 100) {
      feedback = AppLocalizations.of(context)!.relEinsteinReincarnated;
      details = AppLocalizations.of(context)!.relPerfectScoreDetails;
      icon = Icons.workspace_premium;
      color = const Color(0xff00ff41);
    } else if (percent >= 75) {
      feedback = AppLocalizations.of(context)!.relOutstanding;
      details = AppLocalizations.of(context)!.relOutstandingDetails;
      icon = Icons.star;
      color = const Color(0xff4fc3f7);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, color: color, size: 80),
        const SizedBox(height: 24),
        Text(
          feedback,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.relYourScore(_score.toString(), _questions.length.toString(), percent.toStringAsFixed(0)),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            details,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _restartQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff15152a),
                  foregroundColor: const Color(0xff4fc3f7),
                  side: const BorderSide(color: Color(0xff4fc3f7), width: 1.0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.relRetryQuiz,
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4fc3f7),
                  foregroundColor: const Color(0xff0a0a1a),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.relBackToHome,
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
