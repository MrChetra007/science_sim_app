import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../../ui/sim_screen.dart';
import '../../../../l10n/generated/app_localizations.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final AppLocalizations? l10n;

  const LessonScreen({super.key, required this.lesson, this.l10n});

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

  void _goToSim() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SimScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n ?? AppLocalizations.of(context)!;
    final lesson = widget.lesson;
    final totalSteps = lesson.steps.length;
    final isLast = _currentPage == totalSteps - 1;
    final step = lesson.steps[_currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: _ProgressBar(current: _currentPage, total: totalSteps, l10n: l10n),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: totalSteps,
              itemBuilder: (context, index) {
                return _StepCard(
                  lesson: lesson,
                  step: step,
                  stepIndex: index,
                  totalSteps: totalSteps,
                  onOpenSim: _goToSim,
                  l10n: l10n,
                );
              },
            ),
          ),
          _BottomNav(
            currentPage: _currentPage,
            totalSteps: totalSteps,
            isInteractive: step.type == StepType.interactive,
            onBack: _currentPage > 0
                ? () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    )
                : null,
            onNext: () {
              if (isLast) {
                Navigator.pop(context);
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            onOpenSim: _goToSim,
            l10n: l10n,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final AppLocalizations l10n;

  const _ProgressBar({required this.current, required this.total, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (current + 1) / total,
            backgroundColor: const Color(0xFF2A2A3E),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFD2691E)),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.emiStepOf('${current + 1}', '$total'),
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final Lesson lesson;
  final LessonStep step;
  final int stepIndex;
  final int totalSteps;
  final VoidCallback onOpenSim;
  final AppLocalizations l10n;

  const _StepCard({
    required this.lesson,
    required this.step,
    required this.stepIndex,
    required this.totalSteps,
    required this.onOpenSim,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stepIndex == 0) ...[
            Text(
              '${lesson.emoji}  ${l10n.emiLessonBadge} ${lesson.id}',
              style: const TextStyle(
                color: Color(0xFFD2691E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lesson.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lesson.subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2691E).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${l10n.emiLessonBadge} ${lesson.id}',
                    style: const TextStyle(
                      color: Color(0xFFD2691E),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              step.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 20),
          if (step.formula != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD2691E).withValues(alpha: 0.3)),
              ),
              child: Text(
                step.formula!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF00FF41),
                  fontSize: 22,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            step.body,
            style: const TextStyle(
              color: Color(0xFFCCCCDD),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          if (step.type == StepType.interactive) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onOpenSim,
                icon: const Icon(Icons.science, size: 20),
                label: Text(
                  l10n.emiOpenSim,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2691E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentPage;
  final int totalSteps;
  final bool isInteractive;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback onOpenSim;
  final AppLocalizations l10n;

  const _BottomNav({
    required this.currentPage,
    required this.totalSteps,
    required this.isInteractive,
    required this.onBack,
    required this.onNext,
    required this.onOpenSim,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == totalSteps - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A3E))),
      ),
      child: Row(
        children: [
          if (onBack != null)
            TextButton(
              onPressed: onBack,
              child: Text(
                l10n.emiBack,
                style: const TextStyle(color: Colors.white54, fontSize: 15),
              ),
            )
          else
            const SizedBox(width: 72),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == currentPage ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == currentPage
                      ? const Color(0xFFD2691E)
                      : const Color(0xFF3A3A4E),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          isLast
              ? ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2691E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.emiDone),
                )
              : TextButton(
                  onPressed: onNext,
                  child: Text(
                    l10n.emiNext,
                    style: const TextStyle(
                      color: Color(0xFFD2691E),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
