import 'models/lesson.dart';
import '../../../l10n/generated/app_localizations.dart';

List<Lesson> getLessons(AppLocalizations l10n) => [
      Lesson(
        id: 1,
        title: l10n.opticL1Title,
        subtitle: l10n.opticL1Subtitle,
        emoji: '\u{1F9F0}',
        steps: [
          LessonStep(
            title: l10n.opticL1S1Title,
            body: l10n.opticL1S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL1S2Title,
            body: l10n.opticL1S2Body,
            type: StepType.formula,
            formula: l10n.opticL1S2Formula,
          ),
          LessonStep(
            title: l10n.opticL1S3Title,
            body: l10n.opticL1S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL1S4Title,
            body: l10n.opticL1S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 2,
        title: l10n.opticL2Title,
        subtitle: l10n.opticL2Subtitle,
        emoji: '\u{1F9E9}',
        steps: [
          LessonStep(
            title: l10n.opticL2S1Title,
            body: l10n.opticL2S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL2S2Title,
            body: l10n.opticL2S2Body,
            type: StepType.formula,
            formula: l10n.opticL2S2Formula,
          ),
          LessonStep(
            title: l10n.opticL2S3Title,
            body: l10n.opticL2S3Body,
            type: StepType.formula,
            formula: l10n.opticL2S3Formula,
          ),
          LessonStep(
            title: l10n.opticL2S4Title,
            body: l10n.opticL2S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 3,
        title: l10n.opticL3Title,
        subtitle: l10n.opticL3Subtitle,
        emoji: '\u{1F30A}',
        steps: [
          LessonStep(
            title: l10n.opticL3S1Title,
            body: l10n.opticL3S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL3S2Title,
            body: l10n.opticL3S2Body,
            type: StepType.formula,
            formula: l10n.opticL3S2Formula,
          ),
          LessonStep(
            title: l10n.opticL3S3Title,
            body: l10n.opticL3S3Body,
            type: StepType.formula,
            formula: l10n.opticL3S3Formula,
          ),
          LessonStep(
            title: l10n.opticL3S4Title,
            body: l10n.opticL3S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 4,
        title: l10n.opticL4Title,
        subtitle: l10n.opticL4Subtitle,
        emoji: '\u{1F453}',
        steps: [
          LessonStep(
            title: l10n.opticL4S1Title,
            body: l10n.opticL4S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL4S2Title,
            body: l10n.opticL4S2Body,
            type: StepType.formula,
            formula: l10n.opticL4S2Formula,
          ),
          LessonStep(
            title: l10n.opticL4S3Title,
            body: l10n.opticL4S3Body,
            type: StepType.formula,
            formula: l10n.opticL4S3Formula,
          ),
          LessonStep(
            title: l10n.opticL4S4Title,
            body: l10n.opticL4S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
      Lesson(
        id: 5,
        title: l10n.opticL5Title,
        subtitle: l10n.opticL5Subtitle,
        emoji: '\u{1F308}',
        steps: [
          LessonStep(
            title: l10n.opticL5S1Title,
            body: l10n.opticL5S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL5S2Title,
            body: l10n.opticL5S2Body,
            type: StepType.formula,
            formula: l10n.opticL5S2Formula,
          ),
          LessonStep(
            title: l10n.opticL5S3Title,
            body: l10n.opticL5S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.opticL5S4Title,
            body: l10n.opticL5S4Body,
            type: StepType.interactive,
          ),
        ],
      ),
    ];

List<QuizQuestion> getQuizQuestions(AppLocalizations l10n) {
  List<String> parseOptions(String jsonStr) {
    final stripped = jsonStr.substring(1, jsonStr.length - 1);
    return stripped
        .split('","')
        .map((s) => s.replaceAll('"', '').replaceAll('\\"', '"'))
        .toList();
  }

  return [
    QuizQuestion(
      question: l10n.opticQ1Question,
      options: parseOptions(l10n.opticQ1Options),
      correctIndex: int.parse(l10n.opticQ1CorrectIndex),
      explanation: l10n.opticQ1Explanation,
    ),
    QuizQuestion(
      question: l10n.opticQ2Question,
      options: parseOptions(l10n.opticQ2Options),
      correctIndex: int.parse(l10n.opticQ2CorrectIndex),
      explanation: l10n.opticQ2Explanation,
    ),
    QuizQuestion(
      question: l10n.opticQ3Question,
      options: parseOptions(l10n.opticQ3Options),
      correctIndex: int.parse(l10n.opticQ3CorrectIndex),
      explanation: l10n.opticQ3Explanation,
    ),
    QuizQuestion(
      question: l10n.opticQ4Question,
      options: parseOptions(l10n.opticQ4Options),
      correctIndex: int.parse(l10n.opticQ4CorrectIndex),
      explanation: l10n.opticQ4Explanation,
    ),
    QuizQuestion(
      question: l10n.opticQ5Question,
      options: parseOptions(l10n.opticQ5Options),
      correctIndex: int.parse(l10n.opticQ5CorrectIndex),
      explanation: l10n.opticQ5Explanation,
    ),
  ];
}