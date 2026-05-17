import 'package:flutter/material.dart';
import '../lesson_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;
  bool _finished = false;

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (index == quizQuestions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_currentQuestion < quizQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedIndex = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  void _reset() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _selectedIndex = null;
      _answered = false;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return _buildResults();
    }
    return _buildQuestion();
  }

  Widget _buildResults() {
    final pct = (_score / quizQuestions.length * 100).round();
    final passed = pct >= 60;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Quiz Complete'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                passed ? '\u{1F389}' : '\u{1F4AA}',
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 24),
              Text(
                passed ? 'Great Job!' : 'Keep Learning!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$_score / ${quizQuestions.length} correct',
                style: TextStyle(
                  color: passed ? const Color(0xFF00FF41) : const Color(0xFFFFCA28),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$pct% — ${passed ? "You passed!" : "Try again to pass"}',
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.replay),
                  label: const Text('Retry Quiz',
                      style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2691E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back to Lessons',
                  style: TextStyle(color: Colors.white54, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final q = quizQuestions[_currentQuestion];
    final isCorrect = _selectedIndex == q.correctIndex;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Question ${_currentQuestion + 1} of ${quizQuestions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_score/${_currentQuestion + (_answered ? 1 : 0)}',
                style: const TextStyle(
                  color: Color(0xFF00FF41),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(q.options.length, (i) {
                    return _OptionTile(
                      index: i,
                      text: q.options[i],
                      isSelected: _selectedIndex == i,
                      isCorrect: _answered && i == q.correctIndex,
                      isWrong: _answered && _selectedIndex == i && i != q.correctIndex,
                      onTap: () => _selectAnswer(i),
                    );
                  }),
                  if (_answered) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? const Color(0xFF00FF41).withValues(alpha: 0.1)
                            : const Color(0xFFFF1744).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0xFF00FF41).withValues(alpha: 0.3)
                              : const Color(0xFFFF1744).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect
                                    ? const Color(0xFF00FF41)
                                    : const Color(0xFFFF1744),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isCorrect ? 'Correct!' : 'Incorrect',
                                style: TextStyle(
                                  color: isCorrect
                                      ? const Color(0xFF00FF41)
                                      : const Color(0xFFFF1744),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            q.explanation,
                            style: const TextStyle(
                              color: Color(0xFFCCCCDD),
                              fontSize: 14,
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
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D1A),
              border: Border(top: BorderSide(color: Color(0xFF2A2A3E))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _answered ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2691E),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF2A2A3E),
                  disabledForegroundColor: Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _currentQuestion < quizQuestions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  Color _getBg() {
    if (isCorrect) return const Color(0xFF00FF41).withValues(alpha: 0.15);
    if (isWrong) return const Color(0xFFFF1744).withValues(alpha: 0.15);
    if (isSelected) return const Color(0xFFD2691E).withValues(alpha: 0.1);
    return const Color(0xFF1A1A2E);
  }

  Color _getBorder() {
    if (isCorrect) return const Color(0xFF00FF41).withValues(alpha: 0.5);
    if (isWrong) return const Color(0xFFFF1744).withValues(alpha: 0.5);
    if (isSelected) return const Color(0xFFD2691E).withValues(alpha: 0.5);
    return const Color(0xFF2A2A3E);
  }

  Color _getLetterColor() {
    if (isCorrect) return const Color(0xFF00FF41);
    if (isWrong) return const Color(0xFFFF1744);
    return const Color(0xFFD2691E);
  }

  String _letter() => String.fromCharCode(65 + index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _getBg(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getBorder()),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getLetterColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _letter(),
                style: TextStyle(
                  color: _getLetterColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3),
              ),
            ),
            if (isCorrect)
              const Icon(Icons.check_circle, color: Color(0xFF00FF41), size: 22),
            if (isWrong)
              const Icon(Icons.cancel, color: Color(0xFFFF1744), size: 22),
          ],
        ),
      ),
    );
  }
}
