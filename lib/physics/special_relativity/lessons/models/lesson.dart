enum StepType { info, formula, interactive }

enum SimMode { timeDilation, lengthContraction, simultaneity, massEnergy }

class LessonStep {
  final String title;
  final String body;
  final StepType type;
  final String? formula;          // shown in terminal-green box
  final SimMode? linkedSim;       // which sim to open on interactive steps

  const LessonStep({
    required this.title,
    required this.body,
    required this.type,
    this.formula,
    this.linkedSim,
  });
}

class Lesson {
  final int id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<LessonStep> steps;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.steps,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
