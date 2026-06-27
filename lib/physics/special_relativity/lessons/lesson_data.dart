import 'dart:convert';
import 'package:science_lab/l10n/generated/app_localizations.dart';
import 'models/lesson.dart';

List<Lesson> buildLessons(AppLocalizations l10n) {
  return [
    Lesson(
      id: 1,
      title: l10n.relL1Title,
      subtitle: l10n.relL1Subtitle,
      emoji: "📜",
      steps: [
        LessonStep(
          title: l10n.relL1S1Title,
          body: l10n.relL1S1Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL1S2Title,
          body: l10n.relL1S2Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL1S3Title,
          body: l10n.relL1S3Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL1S4Title,
          body: l10n.relL1S4Body,
          type: StepType.interactive,
          linkedSim: SimMode.timeDilation,
        ),
      ],
    ),
    Lesson(
      id: 2,
      title: l10n.relL2Title,
      subtitle: l10n.relL2Subtitle,
      emoji: "⏱️",
      steps: [
        LessonStep(
          title: l10n.relL2S1Title,
          body: l10n.relL2S1Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL2S2Title,
          body: l10n.relL2S2Body,
          type: StepType.formula,
          formula: l10n.relL2S2Formula,
        ),
        LessonStep(
          title: l10n.relL2S3Title,
          body: l10n.relL2S3Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL2S4Title,
          body: l10n.relL2S4Body,
          type: StepType.interactive,
          linkedSim: SimMode.timeDilation,
        ),
      ],
    ),
    Lesson(
      id: 3,
      title: l10n.relL3Title,
      subtitle: l10n.relL3Subtitle,
      emoji: "📏",
      steps: [
        LessonStep(
          title: l10n.relL3S1Title,
          body: l10n.relL3S1Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL3S2Title,
          body: l10n.relL3S2Body,
          type: StepType.formula,
          formula: l10n.relL3S2Formula,
        ),
        LessonStep(
          title: l10n.relL3S3Title,
          body: l10n.relL3S3Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL3S4Title,
          body: l10n.relL3S4Body,
          type: StepType.interactive,
          linkedSim: SimMode.lengthContraction,
        ),
      ],
    ),
    Lesson(
      id: 4,
      title: l10n.relL4Title,
      subtitle: l10n.relL4Subtitle,
      emoji: "⚡",
      steps: [
        LessonStep(
          title: l10n.relL4S1Title,
          body: l10n.relL4S1Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL4S2Title,
          body: l10n.relL4S2Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL4S3Title,
          body: l10n.relL4S3Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL4S4Title,
          body: l10n.relL4S4Body,
          type: StepType.interactive,
          linkedSim: SimMode.simultaneity,
        ),
      ],
    ),
    Lesson(
      id: 5,
      title: l10n.relL5Title,
      subtitle: l10n.relL5Subtitle,
      emoji: "⚛️",
      steps: [
        LessonStep(
          title: l10n.relL5S1Title,
          body: l10n.relL5S1Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL5S2Title,
          body: l10n.relL5S2Body,
          type: StepType.formula,
          formula: l10n.relL5S2Formula,
        ),
        LessonStep(
          title: l10n.relL5S3Title,
          body: l10n.relL5S3Body,
          type: StepType.info,
        ),
        LessonStep(
          title: l10n.relL5S4Title,
          body: l10n.relL5S4Body,
          type: StepType.interactive,
          linkedSim: SimMode.massEnergy,
        ),
      ],
    ),
  ];
}

List<QuizQuestion> buildQuizQuestions(AppLocalizations l10n) {
  return [
    QuizQuestion(
      question: l10n.relQ1Question,
      options: List<String>.from(jsonDecode(l10n.relQ1Options)),
      correctIndex: int.parse(l10n.relQ1CorrectIndex),
      explanation: l10n.relQ1Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ2Question,
      options: List<String>.from(jsonDecode(l10n.relQ2Options)),
      correctIndex: int.parse(l10n.relQ2CorrectIndex),
      explanation: l10n.relQ2Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ3Question,
      options: List<String>.from(jsonDecode(l10n.relQ3Options)),
      correctIndex: int.parse(l10n.relQ3CorrectIndex),
      explanation: l10n.relQ3Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ4Question,
      options: List<String>.from(jsonDecode(l10n.relQ4Options)),
      correctIndex: int.parse(l10n.relQ4CorrectIndex),
      explanation: l10n.relQ4Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ5Question,
      options: List<String>.from(jsonDecode(l10n.relQ5Options)),
      correctIndex: int.parse(l10n.relQ5CorrectIndex),
      explanation: l10n.relQ5Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ6Question,
      options: List<String>.from(jsonDecode(l10n.relQ6Options)),
      correctIndex: int.parse(l10n.relQ6CorrectIndex),
      explanation: l10n.relQ6Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ7Question,
      options: List<String>.from(jsonDecode(l10n.relQ7Options)),
      correctIndex: int.parse(l10n.relQ7CorrectIndex),
      explanation: l10n.relQ7Explanation,
    ),
    QuizQuestion(
      question: l10n.relQ8Question,
      options: List<String>.from(jsonDecode(l10n.relQ8Options)),
      correctIndex: int.parse(l10n.relQ8CorrectIndex),
      explanation: l10n.relQ8Explanation,
    ),
  ];
}
