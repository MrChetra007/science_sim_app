import 'models/lesson.dart';
import '../../../l10n/generated/app_localizations.dart';

List<Lesson> getLessons(AppLocalizations l10n) => [
      Lesson(
        id: 1,
        title: l10n.emiL1Title,
        subtitle: l10n.emiL1Subtitle,
        emoji: '\u{1F50C}',
        steps: [
          LessonStep(
            title: l10n.emiL1S1Title,
            body: l10n.emiL1S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL1S2Title,
            body: l10n.emiL1S2Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL1S3Title,
            body: l10n.emiL1S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL1S4Title,
            body: l10n.emiL1S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 2,
        title: l10n.emiL2Title,
        subtitle: l10n.emiL2Subtitle,
        emoji: '\u{1F4DA}',
        steps: [
          LessonStep(
            title: l10n.emiL2S1Title,
            body: l10n.emiL2S1Body,
            type: StepType.formula,
            formula: l10n.emiL2S1Formula,
          ),
          LessonStep(
            title: l10n.emiL2S2Title,
            body: l10n.emiL2S2Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL2S3Title,
            body: l10n.emiL2S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL2S4Title,
            body: l10n.emiL2S4Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL2S5Title,
            body: l10n.emiL2S5Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 3,
        title: l10n.emiL3Title,
        subtitle: l10n.emiL3Subtitle,
        emoji: '\u{1F504}',
        steps: [
          LessonStep(
            title: l10n.emiL3S1Title,
            body: l10n.emiL3S1Body,
            type: StepType.formula,
            formula: l10n.emiL3S1Formula,
          ),
          LessonStep(
            title: l10n.emiL3S2Title,
            body: l10n.emiL3S2Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL3S3Title,
            body: l10n.emiL3S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL3S4Title,
            body: l10n.emiL3S4Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL3S5Title,
            body: l10n.emiL3S5Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 4,
        title: l10n.emiL4Title,
        subtitle: l10n.emiL4Subtitle,
        emoji: '\u{1F30D}',
        steps: [
          LessonStep(
            title: l10n.emiL4S1Title,
            body: l10n.emiL4S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL4S2Title,
            body: l10n.emiL4S2Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL4S3Title,
            body: l10n.emiL4S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.emiL4S4Title,
            body: l10n.emiL4S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
    ];

List<QuizQuestion> getQuizQuestions(AppLocalizations l10n) {
  QuizQuestion q1(String question, List<String> options, int correct, String explanation) =>
      QuizQuestion(question: question, options: options, correctIndex: correct, explanation: explanation);

  return [
    q1(
      l10n.emiQ1Question,
      _parseOptions(l10n.emiQ1Options),
      int.parse(l10n.emiQ1CorrectIndex),
      l10n.emiQ1Explanation,
    ),
    q1(
      l10n.emiQ2Question,
      _parseOptions(l10n.emiQ2Options),
      int.parse(l10n.emiQ2CorrectIndex),
      l10n.emiQ2Explanation,
    ),
    q1(
      l10n.emiQ3Question,
      _parseOptions(l10n.emiQ3Options),
      int.parse(l10n.emiQ3CorrectIndex),
      l10n.emiQ3Explanation,
    ),
    q1(
      l10n.emiQ4Question,
      _parseOptions(l10n.emiQ4Options),
      int.parse(l10n.emiQ4CorrectIndex),
      l10n.emiQ4Explanation,
    ),
    q1(
      l10n.emiQ5Question,
      _parseOptions(l10n.emiQ5Options),
      int.parse(l10n.emiQ5CorrectIndex),
      l10n.emiQ5Explanation,
    ),
  ];
}

List<String> _parseOptions(String json) {
  final trimmed = json.substring(1, json.length - 1);
  final parts = <String>[];
  int i = 0;
  while (i < trimmed.length) {
    if (trimmed[i] == '"') {
      final close = trimmed.indexOf('"', i + 1);
      if (close == -1) break;
      parts.add(trimmed.substring(i + 1, close));
      i = close + 1;
    } else {
      i++;
    }
  }
  return parts;
}
