import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../../../core/widgets/ad_widgets.dart';
import 'providers/quiz_provider.dart';
import 'quiz_questions.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('pH Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(quizProvider.notifier).reset();
            context.go('/');
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.isComplete
            ? _ResultsView(
                score: state.score,
                total: kQuizQuestions.length,
                onRestart: () => ref.read(quizProvider.notifier).reset(),
              )
            : _QuestionView(
                question: kQuizQuestions[state.currentIndex],
                questionNumber: state.currentIndex + 1,
                total: kQuizQuestions.length,
                selectedIndex: state.selectedAnswer,
                onAnswer: (i) => ref.read(quizProvider.notifier).answer(i),
                onNext: () => ref.read(quizProvider.notifier).next(),
              ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final QuizQuestion question;
  final int questionNumber;
  final int total;
  final int? selectedIndex;
  final Function(int) onAnswer;
  final VoidCallback onNext;

  const _QuestionView({
    required this.question,
    required this.questionNumber,
    required this.total,
    required this.selectedIndex,
    required this.onAnswer,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: questionNumber / total,
            backgroundColor: AppColors.bgElevated,
            valueColor: const AlwaysStoppedAnimation(AppColors.accentPurple),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Question $questionNumber of $total',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            question.question,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._buildOptions(context),
          const SizedBox(height: AppSpacing.md),
          const GlobalBannerAdWidget(),
          const Spacer(),
          if (selectedIndex != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedIndex == question.correctIndex ? 'Correct!' : 'Incorrect',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedIndex == question.correctIndex ? AppColors.accentGreen : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(question.explanation, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentPurple),
              child: Text(questionNumber == total ? 'View Results' : 'Next Question'),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildOptions(BuildContext context) {
    return List.generate(question.options.length, (index) {
      final isCorrect = question.correctIndex == index;
      final isSelected = selectedIndex == index;

      Color itemColor = AppColors.bgSurface;
      if (selectedIndex != null) {
        if (isSelected) {
          itemColor = isCorrect ? AppColors.accentGreen.withOpacity(0.2) : Colors.redAccent.withOpacity(0.2);
        } else if (isCorrect) {
          itemColor = AppColors.accentGreen.withOpacity(0.1);
        }
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: InkWell(
          onTap: () => onAnswer(index),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: itemColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: selectedIndex != null && isCorrect
                    ? AppColors.accentGreen
                    : (isSelected ? Colors.redAccent : AppColors.borderDefault),
                width: isSelected || (selectedIndex != null && isCorrect) ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected || (selectedIndex != null && isCorrect) ? null : AppColors.textHint,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    question.options[index],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (selectedIndex != null && isCorrect)
                  const Icon(Icons.check_circle, color: AppColors.accentGreen)
                else if (isSelected && !isCorrect)
                  const Icon(Icons.cancel, color: Colors.redAccent),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ResultsView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _ResultsView({
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).toInt();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Q', style: TextStyle(fontSize: 64)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Quiz Complete!',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Your Score',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            '$score / $total',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: percentage >= 70 ? AppColors.accentGreen : AppColors.accentOrange,
              fontSize: 64,
            ),
          ),
          Text(
            '$percentage%',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xxl),
          ElevatedButton(
            onPressed: onRestart,
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}