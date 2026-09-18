import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../theme.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lesson = widget.lesson;
    final totalSteps = lesson.steps.length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('${lesson.emoji} ${lesson.title}',
            style: const TextStyle(color: AppColors.text, fontSize: 16)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _progressBar(totalSteps, _currentPage),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalSteps,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return _stepPage(lesson.steps[index], index, totalSteps, l10n);
              },
            ),
          ),
          _bottomNav(totalSteps, _currentPage, l10n),
        ],
      ),
    );
  }

  Widget _progressBar(int total, int current) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(total, (i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: i <= current ? AppColors.accent : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _stepPage(LessonStep step, int index, int total, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.opticStepOf('${index + 1}', '$total'),
            style: const TextStyle(color: AppColors.accent, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            step.title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.body,
            style:
                const TextStyle(color: AppColors.dim, fontSize: 15, height: 1.6),
          ),
          if (step.formula != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
              ),
              child: Text(
                step.formula!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: AppColors.accent,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bottomNav(int total, int current, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (current > 0)
            TextButton.icon(
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              icon: const Icon(Icons.arrow_back, color: AppColors.accent),
              label: Text(l10n.back, style: const TextStyle(color: AppColors.accent)),
            )
          else
            const SizedBox.shrink(),
          if (current < total - 1)
            TextButton.icon(
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              icon: const Icon(Icons.arrow_forward, color: AppColors.accent),
              label: Text(l10n.next, style: const TextStyle(color: AppColors.accent)),
            )
          else
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check, color: AppColors.success),
              label: Text(l10n.opticComplete,
                  style: const TextStyle(color: AppColors.success)),
            ),
        ],
      ),
    );
  }
}