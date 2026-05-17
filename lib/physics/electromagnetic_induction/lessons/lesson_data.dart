import 'models/lesson.dart';

final lessons = [
  const Lesson(
    id: 1,
    title: 'What is Electromagnetic Induction?',
    subtitle: 'Faraday\'s 1831 discovery that changed the world',
    emoji: '\u{1F50C}',
    steps: [
      LessonStep(
        title: 'The Discovery',
        body:
            'In 1831, Michael Faraday discovered that a CHANGING magnetic field creates an electric current in a nearby wire.\n\n'
            'Before Faraday, scientists knew electricity and magnetism were related. He showed exactly how they connect.',
        type: StepType.info,
      ),
      LessonStep(
        title: 'The Water Pipe Analogy',
        body:
            'Imagine a pipe full of water. If you push a plunger through, the water moves.\n\n'
            'A magnet moving through a coil is like that plunger — it "pushes" the electrons in the wire, creating an electric current.\n\n'
            'Key insight: the magnet must be MOVING. A stationary magnet does nothing.',
        type: StepType.info,
      ),
      LessonStep(
        title: 'What You\'ll See',
        body:
            'When the magnet enters the coil, electrons start flowing.\n\n'
            'When the magnet is at the center, moving fastest — the current is strongest.\n\n'
            'When the magnet exits, current flows the opposite direction.\n\n'
            'This alternating current (AC) is what powers your home!',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Try It Yourself',
        body:
            'Open the simulation. Watch what happens to the EMF as you move the magnet:\n\n'
            '1. Slowly move the magnet through the coil\n'
            '2. Watch the green EMF waveform appear\n'
            '3. Try different speeds — what changes?',
        type: StepType.interactive,
      ),
    ],
  ),
  const Lesson(
    id: 2,
    title: 'Faraday\'s Law',
    subtitle: 'EMF = -N \u00D7 \u0394\u03A6 / \u0394t',
    emoji: '\u{1F4DA}',
    steps: [
      LessonStep(
        title: 'The Formula',
        body:
            'Faraday\'s Law is the mathematical heart of induction:\n\n'
            'EMF = -N \u00D7 \u0394\u03A6 / \u0394t\n\n'
            'Let\'s break down each piece.',
        type: StepType.formula,
        formula: 'EMF = \u2212N \u00D7 \u0394\u03A6 / \u0394t',
      ),
      LessonStep(
        title: 'N — Number of Turns',
        body:
            'N = number of wire loops (turns) in the coil.\n\n'
            'Think of it like fishing nets: more loops = more wires cutting through the magnetic field = more induced EMF.\n\n'
            'Doubling N doubles the EMF. This is why real generators use coils with hundreds of turns!',
        type: StepType.info,
      ),
      LessonStep(
        title: '\u0394\u03A6 — Change in Flux',
        body:
            '\u03A6 (Phi) = magnetic flux = the amount of magnetic field passing through the coil.\n\n'
            '\u0394\u03A6 = the CHANGE in flux. When the magnet moves closer, flux increases. When it moves away, flux decreases.\n\n'
            'Bigger magnets or stronger fields = bigger \u0394\u03A6 = bigger EMF.',
        type: StepType.info,
      ),
      LessonStep(
        title: '\u0394t — Time Interval',
        body:
            '\u0394t = the time over which the flux changes.\n\n'
            'Faster motion = smaller \u0394t = larger EMF.\n\n'
            'This is why pushing the magnet through quickly gives a bigger voltage spike than moving it slowly.',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Try It Yourself',
        body:
            'Open the simulation and test each variable:\n\n'
            '1. Adjust the "Turns" slider — does EMF scale with N?\n'
            '2. Adjust "Field Strength" — stronger magnet = more flux?\n'
            '3. Adjust "Speed" — faster motion = bigger EMF?\n\n'
            'Watch the formula panel update LIVE with your changes!',
        type: StepType.interactive,
      ),
    ],
  ),
  const Lesson(
    id: 3,
    title: 'Lenz\'s Law',
    subtitle: 'Why the minus sign? The coil fights back',
    emoji: '\u{1F504}',
    steps: [
      LessonStep(
        title: 'The Minus Sign',
        body:
            'The minus sign in Faraday\'s Law is NOT just a mathematical quirk — it\'s a physical law (Lenz\'s Law).\n\n'
            'It means: the induced current creates a magnetic field that OPPOSES the change that created it.\n\n'
            'Nature hates change! The coil "fights back" against the magnet\'s motion.',
        type: StepType.formula,
        formula: 'EMF = \u2212N \u00D7 \u0394\u03A6 / \u0394t',
      ),
      LessonStep(
        title: 'Approaching Magnet',
        body:
            'When the magnet\'s NORTH pole approaches from above:\n\n'
            '1. Flux through the coil INCREASES\n'
            '2. The induced current creates a NORTH pole facing UP\n'
            '3. This REPELS the approaching magnet\n\n'
            'The coil says: "Stop getting closer!" \u2191',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Retreating Magnet',
        body:
            'When the magnet moves AWAY:\n\n'
            '1. Flux through the coil DECREASES\n'
            '2. The induced current creates a SOUTH pole facing UP\n'
            '3. This ATTRACTS the retreating magnet\n\n'
            'The coil says: "Don\'t leave!" \u2190',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Clockwise vs Counter-Clockwise',
        body:
            'The direction of the induced current tells you what the coil is doing:\n\n'
            'RED glow (CW) = coil creating a north pole (repelling the approaching N pole)\n'
            'BLUE glow (CCW) = coil creating a south pole (attracting the retreating N pole)\n\n'
            'This is energy conservation in action — you have to DO WORK to move the magnet against this opposing force.',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Try It Yourself',
        body:
            'Open the simulation and focus on the coil color:\n\n'
            '1. Watch the glow — red when EMF is positive, blue when negative\n'
            '2. Can you predict which color appears when the magnet enters vs exits?\n'
            '3. Drag the magnet manually and feel the opposition (watch the arrows!)',
        type: StepType.interactive,
      ),
    ],
  ),
  const Lesson(
    id: 4,
    title: 'Real-World Applications',
    subtitle: 'Induction is everywhere around you',
    emoji: '\u{1F30D}',
    steps: [
      LessonStep(
        title: 'Electric Generators',
        body:
            'Every power plant uses electromagnetic induction!\n\n'
            'Turbines (steam, water, or wind) spin magnets inside coils of wire, generating the electricity that powers our homes.\n\n'
            'The only difference from our simulation: the magnet ROTATES instead of moving up and down.\n\n'
            'One spinning magnet = a continuous AC waveform!',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Wireless Charging',
        body:
            'Your phone\'s wireless charger is a real-world Faraday\'s Law demo!\n\n'
            'The charger contains a coil that creates a rapidly changing magnetic field.\n'
            'Your phone contains another coil. The changing field induces a current in it.\n\n'
            'That current charges your battery — no wires needed!\n\n'
            'Faraday\'s Law, in your pocket, every day.',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Induction Cooktops',
        body:
            'Induction cooktops use changing magnetic fields to heat pans DIRECTLY.\n\n'
            'A coil under the glass creates a high-frequency changing field.\n'
            'This induces "eddy currents" in the metal pan.\n'
            'The resistance of the pan to these currents creates heat.\n\n'
            'No flame. No glowing element. Just pure induction heating your food!',
        type: StepType.info,
      ),
      LessonStep(
        title: 'Try It Yourself',
        body:
            'Open the simulation one final time. Now that you understand the full physics:\n\n'
            '1. Can you explain exactly why the EMF peaks at the center?\n'
            '2. Why does increasing turns increase the EMF?\n'
            '3. What does the minus sign physically mean?\n\n'
            'Everything you see in the sim applies directly to real-world technology!',
        type: StepType.interactive,
      ),
    ],
  ),
];

const quizQuestions = [
  QuizQuestion(
    question: 'What did Michael Faraday discover in 1831?',
    options: [
      'That electricity flows through copper wires',
      'That a changing magnetic field induces an electric current',
      'That magnets attract iron',
      'That light is an electromagnetic wave',
    ],
    correctIndex: 1,
    explanation:
        'Faraday discovered electromagnetic induction — a changing magnetic field creates (induces) an electric current in a nearby conductor.',
  ),
  QuizQuestion(
    question: 'In Faraday\'s Law, what does the variable N represent?',
    options: [
      'The strength of the magnet',
      'The number of turns in the coil',
      'The speed of the magnet',
      'The voltage output',
    ],
    correctIndex: 1,
    explanation:
        'N is the number of wire loops (turns) in the coil. More turns = more EMF, because more wires intersect the changing magnetic field.',
  ),
  QuizQuestion(
    question: 'According to Lenz\'s Law, what does the minus sign in EMF = \u2212N\u00D7\u0394\u03A6/\u0394t mean?',
    options: [
      'The EMF is always negative',
      'Energy is lost to heat',
      'The induced current opposes the change in flux',
      'The formula is incomplete',
    ],
    correctIndex: 2,
    explanation:
        'The minus sign represents Lenz\'s Law: the induced current creates a magnetic field that OPPOSES the change that produced it. The coil "fights back."',
  ),
  QuizQuestion(
    question: 'When is the induced EMF maximum in the simulation?',
    options: [
      'When the magnet is at the top of its motion',
      'When the magnet is at the bottom of its motion',
      'When the magnet is at the coil center, moving fastest',
      'When the magnet is stationary at any position',
    ],
    correctIndex: 2,
    explanation:
        'EMF is proportional to \u0394\u03A6/\u0394t — the RATE of change of flux. At the center, the magnet is moving fastest, so flux changes fastest, giving peak EMF.',
  ),
  QuizQuestion(
    question: 'Which of these is NOT an application of electromagnetic induction?',
    options: [
      'Electric power generators',
      'Wireless phone charging',
      'A standard flashlight battery',
      'Induction cooktops',
    ],
    correctIndex: 2,
    explanation:
        'Batteries use chemical reactions to produce electricity, not electromagnetic induction. Generators, wireless chargers, and induction cooktops all use Faraday\'s Law directly.',
  ),
];
