import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../lesson_data.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';
import '../../screens/home_screen.dart' as mode_chooser;
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lessons = getLessons(l10n);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.opticHomeTitle,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFF131B2E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.opticLessons,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...lessons.map((lesson) => _lessonCard(context, lesson)),
            const SizedBox(height: 24),
            Text(
              l10n.opticPractice,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _simCard(context, l10n),
            const SizedBox(height: 12),
            _quizCard(context, l10n),
            const SizedBox(height: 16),
            const SafeArea(child: GlobalBannerAdWidget()),
          ],
        ),
      ),
    );
  }

  Widget _lessonCard(BuildContext context, Lesson lesson) {
    return Card(
      color: const Color(0xFF1C2640),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2E3D60)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Text(lesson.emoji, style: const TextStyle(fontSize: 32)),
        title: Text(
          '${lesson.id}: ${lesson.title}',
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          lesson.subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.accent,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
          );
        },
      ),
    );
  }

  Widget _simCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      color: const Color(0xFF1C2640),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2E3D60)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Text('\u{1F9E9}', style: TextStyle(fontSize: 32)),
        title: Text(
          l10n.opticSimulation,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          l10n.opticSimulationSubtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.accent,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const mode_chooser.HomeScreen()),
          );
        },
      ),
    );
  }

  Widget _quizCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      color: const Color(0xFF1C2640),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2E3D60)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Text('\u{1F4DD}', style: TextStyle(fontSize: 32)),
        title: Text(
          l10n.opticQuiz,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          l10n.opticQuizSubtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.accent,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuizScreen()),
          );
        },
      ),
    );
  }
}