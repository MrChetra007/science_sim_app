import 'models/lesson.dart';

final List<Lesson> lessons = [
  const Lesson(
    id: 1,
    title: "Einstein's Postulates",
    subtitle: "The foundation of relativity",
    emoji: "📜",
    steps: [
      LessonStep(
        title: "The Speed of Light is Constant",
        body: r"Einstein's first key postulate is that the speed of light in a vacuum ($c \approx 3 \times 10^8$ m/s) is the same for all observers, regardless of their motion or the motion of the light source. This means if you shine a flashlight while riding a rocket, an observer on the ground measures the light moving at exactly $c$, not $c + v_{rocket}$!",
        type: StepType.info,
      ),
      LessonStep(
        title: "The Principle of Relativity",
        body: "The second postulate states that the laws of physics are identical in all inertial (non-accelerating) reference frames. There is no 'absolute rest' frame in the universe. Whether you are floating in deep space or sitting on a train traveling at constant speed, any physics experiment you perform will yield the same results.",
        type: StepType.info,
      ),
      LessonStep(
        title: "Michelson-Morley Experiment",
        body: "Historically, physicists believed space was filled with a substance called the 'aether' through which light waves traveled. The famous Michelson-Morley experiment tried to measure Earth's velocity relative to this aether but failed to find any speed difference. This 'null result' confirmed that the speed of light is indeed constant in all directions and led directly to Einstein's theory of Special Relativity.",
        type: StepType.info,
      ),
      LessonStep(
        title: "Let's Observe Time Dilation",
        body: "Because the speed of light is constant, time itself must bend to keep it that way! Let's explore the Time Dilation simulation to see how a moving clock ticks slower.",
        type: StepType.interactive,
        linkedSim: SimMode.timeDilation,
      ),
    ],
  ),
  const Lesson(
    id: 2,
    title: "Time Dilation",
    subtitle: "Moving clocks run slow",
    emoji: "⏱️",
    steps: [
      LessonStep(
        title: "The Light Clock Thought Experiment",
        body: "Imagine a clock made of two parallel mirrors where a photon bounces up and down. When the clock is at rest, the photon travels straight up and down. But when the clock moves, the photon must travel a longer, diagonal path to hit the mirrors. Since the speed of light is constant, the longer path means it takes more time to complete one bounce. Thus, the moving clock ticks slower!",
        type: StepType.info,
      ),
      LessonStep(
        title: "The Formula",
        body: r"The relationship between proper time ($t_0$, measured by an observer moving with the clock) and dilated time ($t'$, measured by a stationary observer) is given by the Lorentz factor $\gamma$ (gamma). As speed $v$ approaches $c$, gamma shoots up to infinity, meaning time slows down dramatically for the moving object.",
        type: StepType.formula,
        formula: "t' = γ × t₀\nγ = 1 / √(1 - β²)\nβ = v / c",
      ),
      LessonStep(
        title: "Real World Proof: GPS Satellites",
        body: "Time dilation is not just a theory; it is a daily engineering challenge! Global Positioning System (GPS) satellites move at high speeds around Earth and experience time dilation. Because they run slightly slower than Earth clocks (and because of gravity, which is General Relativity), their atomic clocks must be corrected by about 7 microseconds per day to keep GPS accurate. Without relativistic adjustments, GPS navigation would fail within hours!",
        type: StepType.info,
      ),
      LessonStep(
        title: "Explore the Light Clock",
        body: "Adjust the velocity slider to see the diagonal path of the photon widen and watch the moving clock hands slow down relative to the rest frame.",
        type: StepType.interactive,
        linkedSim: SimMode.timeDilation,
      ),
    ],
  ),
  const Lesson(
    id: 3,
    title: "Length Contraction",
    subtitle: "Space shrinks at high speeds",
    emoji: "📏",
    steps: [
      LessonStep(
        title: "Why Space Contracts",
        body: "If time dilates (slows down) for a moving object, then to keep the speed of light constant, distances must also change! An observer looking at a fast-moving object will measure its length as contracted (shorter) along its direction of motion. However, the object itself does not feel any squishing; in its own reference frame, its length is perfectly normal.",
        type: StepType.info,
      ),
      LessonStep(
        title: "The Formula",
        body: r"The contracted length ($L'$) is equal to the rest length ($L_0$) divided by the Lorentz factor ($\gamma$). Because $\gamma \ge 1$, the measured length $L'$ is always less than or equal to $L_0$. The faster the object moves, the more it shrinks in the direction of travel.",
        type: StepType.formula,
        formula: "L' = L₀ / γ",
      ),
      LessonStep(
        title: "Real World Proof: Muon Decay",
        body: "Muons are subatomic particles created when cosmic rays strike Earth's upper atmosphere. They have a very short lifespan (2.2 microseconds) and should decay long before hitting the ground. But because they travel near the speed of light, their clocks dilate, letting them live longer from Earth's perspective. From the muon's own perspective, Earth's atmosphere is heavily contracted, meaning the distance they have to travel is short enough for them to make it to the surface!",
        type: StepType.info,
      ),
      LessonStep(
        title: "See it in Action",
        body: "Watch a spaceship shrink as its velocity increases, and compare its rest length reference against the contracted scale.",
        type: StepType.interactive,
        linkedSim: SimMode.lengthContraction,
      ),
    ],
  ),
  const Lesson(
    id: 4,
    title: "Relativity of Simultaneity",
    subtitle: "No universal 'now'",
    emoji: "⚡",
    steps: [
      LessonStep(
        title: "The Concept",
        body: "If two events happen at the same time in one reference frame, do they happen at the same time in all frames? The surprising answer is: NO! Einstein showed that simultaneity is relative. Events that are simultaneous in one frame are not simultaneous in another frame that is moving relative to the first.",
        type: StepType.info,
      ),
      LessonStep(
        title: "The Train Thought Experiment",
        body: "Imagine a passenger sitting at the center of a moving train, and an observer standing on the station platform. Just as the passenger passes the platform observer, lightning strikes the front and back of the train simultaneously according to the platform observer. The light wavefronts meet exactly at the platform observer. But because the train is moving, the passenger travels *towards* the front strike's light and *away* from the back strike's light, receiving the front flash first. Therefore, the passenger concludes that the front strike happened first!",
        type: StepType.info,
      ),
      LessonStep(
        title: "No Universal Time",
        body: "Since both observers are correct in their own reference frames, there is no absolute timeline for the universe. Events do not have a universal 'before' or 'after' unless they are causally connected (i.e. one could cause the other).",
        type: StepType.info,
      ),
      LessonStep(
        title: "Trigger the Lightning",
        body: "Open the Simultaneity simulation. Tap the trigger button to see how the expansion of light wavefronts reaches the platform and train observers at different points.",
        type: StepType.interactive,
        linkedSim: SimMode.simultaneity,
      ),
    ],
  ),
  const Lesson(
    id: 5,
    title: "Mass-Energy Equivalence",
    subtitle: "E = mc² and relativistic energy",
    emoji: "⚛️",
    steps: [
      LessonStep(
        title: "Mass is Condensed Energy",
        body: r"Einstein's most famous equation, $E = mc^2$, reveals that mass ($m$) and energy ($E$) are actually two forms of the same thing. Mass can be converted into energy, and energy can be converted into mass. Because the speed of light squared ($c^2 \approx 9 \times 10^{16}$) is an enormous number, a tiny amount of mass contains a colossal amount of rest energy.",
        type: StepType.info,
      ),
      LessonStep(
        title: "The Relativistic Formula",
        body: r"When an object moves, its total energy ($E$) increases due to its kinetic energy ($KE$). As the velocity approaches $c$, the kinetic energy grows exponentially. Because it takes infinite energy to accelerate a massive object to the speed of light, no object with mass can ever reach or exceed $c$.",
        type: StepType.formula,
        formula: "E₀ = mc² (Rest Energy)\nKE = (γ - 1) × mc² (Kinetic Energy)\nE_total = γ × mc² (Total Energy)",
      ),
      LessonStep(
        title: "Nuclear Fission & Fusion",
        body: r"In nuclear power plants, heavy uranium nuclei split (fission). The combined mass of the resulting fragments is slightly *less* than the mass of the original uranium atom. This missing mass ($m$) is converted directly into thermal and radiation energy ($E$) according to $E = mc^2$, powering entire cities with just a few grams of fuel.",
        type: StepType.info,
      ),
      LessonStep(
        title: "Split the Nucleus",
        body: "Try the Mass-Energy simulation. Trigger a fission reaction to release mass-energy, and adjust the velocity slider to see how relativistic kinetic energy explodes at high velocities.",
        type: StepType.interactive,
        linkedSim: SimMode.massEnergy,
      ),
    ],
  ),
];

final List<QuizQuestion> quizQuestions = [
  const QuizQuestion(
    question: "According to Einstein's postulates, if you travel in a spaceship at 0.5c and turn on a searchlight pointing forward, what is the speed of the light beam as measured by an observer on Earth?",
    options: [
      "1.5 c",
      "1.0 c",
      "0.5 c",
      "0.75 c"
    ],
    correctIndex: 1,
    explanation: r"Einstein's first postulate states that the speed of light in a vacuum is always constant ($c$) for all observers, regardless of the relative motion of the source and observer. Thus, the Earth observer will measure exactly $1.0c$.",
  ),
  const QuizQuestion(
    question: "In the light clock thought experiment, why does the moving clock tick slower for a stationary observer?",
    options: [
      "The mirrors are compressed by length contraction.",
      "The light travels a longer diagonal path, and since the speed of light is constant, it takes longer.",
      "The speed of light slows down when the clock is in motion.",
      "Mechanical friction in the clock increases with speed."
    ],
    correctIndex: 1,
    explanation: r"Because the clock is moving, the photon must travel a longer, diagonal path to bounce between the mirrors. Since the speed of light must remain constant ($c$), this longer distance takes more time, meaning the clock ticks slower from the stationary frame.",
  ),
  const QuizQuestion(
    question: "At what speed does an object's length contract to exactly half (50%) of its rest length?",
    options: [
      "0.50 c",
      "0.707 c",
      "0.866 c",
      "0.99 c"
    ],
    correctIndex: 2,
    explanation: r"Length contraction is given by $L' = L_0 / \gamma$. For $L'$ to be $0.5 L_0$, we need $\gamma = 2.0$. Solving $\gamma = 1 / \sqrt{1 - \beta^2} = 2$ gives $\beta = \sqrt{3}/2 \approx 0.866$. Thus, the speed must be $0.866c$.",
  ),
  const QuizQuestion(
    question: "Which of the following particles serves as direct atmospheric evidence of both time dilation and length contraction?",
    options: [
      "Electrons",
      "Photons",
      "Muons",
      "Neutrons"
    ],
    correctIndex: 2,
    explanation: "Muons created in the upper atmosphere travel near the speed of light. Due to time dilation, they live long enough to reach Earth. From their own frame, length contraction shortens the travel distance, allowing them to reach the ground.",
  ),
  const QuizQuestion(
    question: "In the train lightning experiment, the platform observer sees both lightning bolts strike simultaneously. What does the train observer see?",
    options: [
      "Both strikes occur simultaneously.",
      "The front strike (in direction of motion) occurs first.",
      "The back strike occurs first.",
      "No lightning strikes are visible."
    ],
    correctIndex: 1,
    explanation: "As the train observer moves toward the front strike and away from the back strike, they encounter the light wavefront from the front strike first. Since the speed of light is constant, they conclude that the front strike happened first.",
  ),
  const QuizQuestion(
    question: "Why can't an object with mass reach the speed of light?",
    options: [
      "It would shrink to zero volume and disappear.",
      "It would run out of fuel.",
      "Its relativistic kinetic energy approaches infinity, requiring infinite work to reach c.",
      "Gravity would pull it back."
    ],
    correctIndex: 2,
    explanation: r"Relativistic kinetic energy is $KE = (\gamma - 1)mc^2$. As $\beta \rightarrow 1.0$, $\gamma \rightarrow \infty$, meaning the kinetic energy required to accelerate the object to $c$ becomes infinite.",
  ),
  const QuizQuestion(
    question: "A nuclear power plant releases energy through fission. Where does this energy come from?",
    options: [
      "Chemical combustion of atomic bonds.",
      "A small amount of mass is destroyed and converted into energy.",
      "Relativistic compression of the fuel rod.",
      "Absorption of cosmic rays."
    ],
    correctIndex: 1,
    explanation: r"In fission, the total mass of the products is slightly less than the initial mass of the nucleus. This mass difference ($m$) is converted directly into energy ($E$) according to $E = mc^2$.",
  ),
  const QuizQuestion(
    question: r"What is the proper time ($t_0$) of an event?",
    options: [
      "The time measured in a reference frame where the observer is at rest relative to the events.",
      "The time measured on Earth's surface.",
      "The time shown by a clock moving at the speed of light.",
      "Universal cosmological time."
    ],
    correctIndex: 0,
    explanation: r"Proper time ($t_0$) is defined as the time interval between two events measured by an observer who is at rest relative to those events (e.g. using a clock that is present at both events).",
  ),
];
