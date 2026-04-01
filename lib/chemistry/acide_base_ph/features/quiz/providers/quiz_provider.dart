import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../quiz_questions.dart';
import '../../../core/services/audio_service.dart';

class QuizState {
  final int currentIndex;
  final int score;
  final int? selectedAnswer;
  final bool isComplete;

  const QuizState({
    this.currentIndex = 0,
    this.score = 0,
    this.selectedAnswer,
    this.isComplete = false,
  });

  QuizState copyWith({
    int? currentIndex,
    int? score,
    int? selectedAnswer,
    bool? isComplete,
  }) => QuizState(
    currentIndex: currentIndex ?? this.currentIndex,
    score: score ?? this.score,
    selectedAnswer: selectedAnswer, // Can be null
    isComplete: isComplete ?? this.isComplete,
  );
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(const QuizState());

  void answer(int index) {
    if (state.selectedAnswer != null) return;

    final isCorrect = kQuizQuestions[state.currentIndex].correctIndex == index;
    if (isCorrect) {
      AudioService.playCorrect();
    }
    state = state.copyWith(
      selectedAnswer: index,
      score: isCorrect ? state.score + 1 : state.score,
    );
  }

  void next() {
    if (state.currentIndex < kQuizQuestions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedAnswer: null,
      );
    } else {
      state = state.copyWith(isComplete: true);
    }
  }

  void reset() {
    state = const QuizState();
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>(
  (ref) => QuizNotifier(),
);
