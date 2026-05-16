import 'models/lesson.dart';
import '../../../l10n/generated/app_localizations.dart';

List<Lesson> getLessons(AppLocalizations l10n) => [
      Lesson(
        id: 1,
        title: l10n.shmLesson1Title,
        subtitle: l10n.shmLesson1Subtitle,
        emoji: '\u{1F30A}',
        steps: [
          LessonStep(
            title: l10n.shmL1S1Title,
            body: l10n.shmL1S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL1S2Title,
            body: l10n.shmL1S2Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL1S3Title,
            body: l10n.shmL1S3Body,
            type: StepType.formula,
            formula: l10n.shmL1S3Formula,
          ),
          LessonStep(
            title: l10n.shmL1S4Title,
            body: l10n.shmL1S4Body,
            type: StepType.info,
          ),
        ],
      ),
      Lesson(
        id: 2,
        title: l10n.shmLesson2Title,
        subtitle: l10n.shmLesson2Subtitle,
        emoji: '\u{1F4E6}',
        steps: [
          LessonStep(
            title: l10n.shmL2S1Title,
            body: l10n.shmL2S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL2S2Title,
            body: l10n.shmL2S2Body,
            type: StepType.formula,
            formula: l10n.shmL2S2Formula,
          ),
          LessonStep(
            title: l10n.shmL2S3Title,
            body: l10n.shmL2S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL2S4Title,
            body: l10n.shmL2S4Body,
            type: StepType.formula,
            formula: l10n.shmL2S4Formula,
          ),
        ],
      ),
      Lesson(
        id: 3,
        title: l10n.shmLesson3Title,
        subtitle: l10n.shmLesson3Subtitle,
        emoji: '\u{23F0}',
        steps: [
          LessonStep(
            title: l10n.shmL3S1Title,
            body: l10n.shmL3S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL3S2Title,
            body: l10n.shmL3S2Body,
            type: StepType.formula,
            formula: l10n.shmL3S2Formula,
          ),
          LessonStep(
            title: l10n.shmL3S3Title,
            body: l10n.shmL3S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL3S4Title,
            body: l10n.shmL3S4Body,
            type: StepType.formula,
            formula: l10n.shmL3S4Formula,
          ),
        ],
      ),
      Lesson(
        id: 4,
        title: l10n.shmLesson4Title,
        subtitle: l10n.shmLesson4Subtitle,
        emoji: '\u{1F30D}',
        steps: [
          LessonStep(
            title: l10n.shmL4S1Title,
            body: l10n.shmL4S1Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL4S2Title,
            body: l10n.shmL4S2Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL4S3Title,
            body: l10n.shmL4S3Body,
            type: StepType.info,
          ),
          LessonStep(
            title: l10n.shmL4S4Title,
            body: l10n.shmL4S4Body,
            type: StepType.info,
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
      question: l10n.shmQ1Question,
      options: parseOptions(l10n.shmQ1Options),
      correctIndex: int.parse(l10n.shmQ1CorrectIndex),
      explanation: l10n.shmQ1Explanation,
    ),
    QuizQuestion(
      question: l10n.shmQ2Question,
      options: parseOptions(l10n.shmQ2Options),
      correctIndex: int.parse(l10n.shmQ2CorrectIndex),
      explanation: l10n.shmQ2Explanation,
    ),
    QuizQuestion(
      question: l10n.shmQ3Question,
      options: parseOptions(l10n.shmQ3Options),
      correctIndex: int.parse(l10n.shmQ3CorrectIndex),
      explanation: l10n.shmQ3Explanation,
    ),
    QuizQuestion(
      question: l10n.shmQ4Question,
      options: parseOptions(l10n.shmQ4Options),
      correctIndex: int.parse(l10n.shmQ4CorrectIndex),
      explanation: l10n.shmQ4Explanation,
    ),
    QuizQuestion(
      question: l10n.shmQ5Question,
      options: parseOptions(l10n.shmQ5Options),
      correctIndex: int.parse(l10n.shmQ5CorrectIndex),
      explanation: l10n.shmQ5Explanation,
    ),
  ];
}
