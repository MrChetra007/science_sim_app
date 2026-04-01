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

const List<QuizQuestion> kQuizQuestions = [
  QuizQuestion(
    question: 'What pH value does pure water have at 25°C?',
    options: ['0', '5', '7', '14'],
    correctIndex: 2,
    explanation: 'Pure water is perfectly neutral at pH 7 because [H⁺] = [OH⁻] = 10⁻⁷ mol/L.',
  ),
  QuizQuestion(
    question: 'Which substance has the LOWEST pH?',
    options: ['Lemon juice', 'Battery acid', 'Vinegar', 'Coffee'],
    correctIndex: 1,
    explanation: 'Battery acid (sulfuric acid) has a pH near 0 — the most acidic common substance.',
  ),
  QuizQuestion(
    question: 'What color does litmus turn in an acidic solution?',
    options: ['Blue', 'Green', 'Yellow', 'Red'],
    correctIndex: 3,
    explanation: 'Litmus paper turns red in acids and blue in bases.',
  ),
  QuizQuestion(
    question: 'What happens when a strong acid and strong base are mixed in equal amounts?',
    options: ['pH drops to 0', 'Solution becomes neutral (pH 7)', 'pH rises to 14', 'Nothing happens'],
    correctIndex: 1,
    explanation: 'This is called neutralization: HCl + NaOH → NaCl + H₂O, producing a neutral salt solution.',
  ),
  QuizQuestion(
    question: 'Which value represents a BASIC solution?',
    options: ['pH 3', 'pH 7', 'pH 9', 'pH 2'],
    correctIndex: 2,
    explanation: 'Any pH above 7 is basic (alkaline). pH 9 is mildly basic — like baking soda.',
  ),
];
