# 〰️ Wave Lab
### Interactive Wave Physics Simulation — Flutter App

> **The only mobile app that shows you the wave equation updating live as you move the sliders — with step-by-step maths explaining every formula.**

---

## What Is This?

Wave Lab is a wave physics simulation app for iOS and Android, built with Flutter. It lets students and educators visualise transverse waves, standing waves, interference, the Doppler effect, and more — live, interactive, and beautiful.

Think of it as a physics lab in your pocket. Move a slider, watch the wave change, and read exactly why the maths works — in plain English, step by step.

It is the companion app to **Ballista** (Projectile Motion Lab), built on the same holographic UI design system and the same educational philosophy: *don't just show the answer, show the why.*

---

## Features

### Wave Types
| Wave | Description |
|---|---|
| Transverse | Classic sine wave with adjustable amplitude and frequency |
| Longitudinal | Compression and rarefaction visualisation |
| Standing Wave | Nodes and antinodes, harmonic selector n=1 to n=6 |
| Travelling Wave | Real-time wave propagation animation |
| Interference | Superposition of two waves — constructive and destructive |
| Doppler Effect | Moving source animation with frequency shift |

### Physics Parameters You Can Adjust
- **Amplitude (A)** — 0.1 to 5.0 m
- **Frequency (f)** — 0.1 to 20 Hz
- **Wavelength (λ)** — derived live from v = fλ
- **Wave Speed (v)** — presets for air, water, steel, vacuum, or custom
- **Phase Difference (φ)** — for interference mode
- **Source Velocity** — for Doppler mode
- **Damping** — energy loss over distance toggle

### Educational Tools
- **Maths Derivation Module** — step-by-step derivation of v = fλ, T = 1/f, standing wave conditions, and the Doppler formula, with your live simulation values substituted into every formula
- **Live Wave Equation HUD** — shows y(x,t) = A sin(kx − ωt + φ) updating in real time
- **Oscilloscope Panel** — fl_chart powered waveform graph with time and position axes
- **Vector Overlay** — displacement, velocity and acceleration vectors on the wave
- **Formula Reference Screen** — all wave kinematic equations in one place
- **Comparison / Ghost Mode** — keep the previous wave visible for side-by-side comparison

### Challenge Mode
- **Target Frequency** — tune a wave to match a target within tolerance
- **Interference Puzzle** — set two waves to produce a given resultant pattern
- **Standing Wave Challenge** — find the correct frequency for the n-th harmonic
- Score system, streak counter, leaderboard

### Experience
- 60fps animated sine wave home screen
- Particle field oscillating in wave patterns
- Audio tone generator — plays the actual frequency you are simulating
- Slow motion mode (0.1× speed)
- Haptic feedback on parameter snap points
- Saves all your settings automatically

---

## Free vs Pro

Wave Lab is free to download. A one-time **Pro unlock ($3.99)** gives you access to the full feature set — no subscription, no ads, restores automatically on all your devices with the same Google Account or Apple ID.

| Feature | Free | Pro |
|---|:---:|:---:|
| Transverse Wave | ✓ | ✓ |
| Longitudinal Wave | ✗ | ✓ |
| Standing Wave (n=1 only) | ✓ | ✓ |
| Standing Wave (n=1 to 6) | ✗ | ✓ |
| Interference Mode | ✗ | ✓ |
| Doppler Effect | ✗ | ✓ |
| Wave Media Presets (Air only) | ✓ | ✓ |
| All Media + Custom Speed | ✗ | ✓ |
| Damping / Attenuation | ✗ | ✓ |
| Phase Difference Control | ✗ | ✓ |
| Maths Derivation Module | ✗ | ✓ |
| Live Formula HUD | Basic | Full |
| Oscilloscope Graph Panel | ✗ | ✓ |
| Vector Overlay | ✗ | ✓ |
| Comparison / Ghost Mode | ✗ | ✓ |
| Audio Tone Generator | ✗ | ✓ |
| Slow Motion Mode | ✗ | ✓ |
| Challenge Mode | Preview | Full |
| Formula Reference Screen | ✗ | ✓ |
| Export Data CSV | ✗ | ✓ |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x — iOS + Android from one codebase |
| Wave Rendering | CustomPainter — direct canvas sine wave drawing at 60fps |
| Game Layer | Flame Engine — Doppler animation and Challenge Mode |
| State Management | Riverpod — reactive, predictable |
| Graphs | fl_chart — oscilloscope waveform panel |
| Audio | flutter_soloud — real frequency tone generation |
| In-App Purchase | in_app_purchase ^3.2.0 — no backend required |
| Persistence | shared_preferences — settings and pro unlock status |
| Maths Engine | Custom Dart WaveSolver class |

---

## Project Structure

```
lib/
├── main.dart
├── providers/
│   └── wave_provider.dart          # Riverpod state — all wave parameters
├── physics/
│   └── wave_solver.dart            # Core maths: v=fλ, standing waves, Doppler
├── screens/
│   ├── home_screen.dart            # Animated sine wave home
│   ├── simulation_screen.dart      # Main simulation canvas
│   ├── formula_reference_screen.dart
│   └── challenge_screen.dart
├── widgets/
│   ├── control_panel.dart          # Parameter sliders
│   ├── results_panel.dart          # Live HUD readouts
│   ├── oscilloscope_graphs.dart    # fl_chart waveform panels
│   ├── math_solver_overlay.dart    # Step-by-step derivation sheet
│   ├── pro_upgrade_overlay.dart    # IAP paywall sheet
│   └── pro_gate.dart               # Wrapper widget for locked features
├── services/
│   └── iap_service.dart            # in_app_purchase integration
└── painters/
    ├── wave_painter.dart           # Core sine wave CustomPainter
    ├── interference_painter.dart   # Two-wave superposition painter
    ├── doppler_painter.dart        # Moving source painter
    └── standing_wave_painter.dart  # Nodes and antinodes painter
```

---

## Development Phases

### Phase 1 — Foundation
Project setup, Flutter + Riverpod scaffold, `WaveSolver` Dart class (v=fλ, T=1/f, standing wave equations), basic sine wave `CustomPainter` rendering.

### Phase 2 — Core Simulation
Transverse and longitudinal wave renderers, live parameter sliders (A, f, λ, v), HUD readouts, live wave equation display y(x,t) = A sin(kx − ωt).

### Phase 3 — Advanced Waves
Standing wave with harmonic selector, interference superposition renderer, Doppler effect animation, wave media presets (air, water, steel, vacuum).

### Phase 4 — Education Layer
Maths Derivation Module (mirrors Ballista pattern), oscilloscope fl_chart panel, vector overlay, formula reference screen, comparison ghost mode.

### Phase 5 — Polish and Ship
Challenge mode, audio tone generator, slow motion, home screen animation, Pro IAP integration ($3.99), App Store and Play Store submission.

---

---

# 〰️ SHM Lab
### Simple Harmonic Motion — Interactive Lessons, Quiz & Simulation

> **Learn SHM through structured lessons, test yourself with a quiz, and experiment with a live spring-mass & pendulum simulation.**

## What Is This?

SHM Lab is a self-contained module inside the Science Lab app that teaches Simple Harmonic Motion through three modes:
- **Lessons** — 4 structured lessons covering what SHM is, period & frequency, energy in SHM, and real-world applications
- **Quiz** — 5 multiple-choice questions with instant feedback and scoring
- **Simulation** — Interactive Flame-powered spring-mass and pendulum simulator with real-time graphs, energy bars, and vector overlays

## Features

- 4 progressive lessons with formulas (Hooke's Law, period, energy, velocity)
- 5-question quiz with pass/fail results
- Interactive simulation with spring-mass and pendulum modes
- Real-time position / velocity / acceleration graphs
- Kinetic & potential energy bars
- Adjustable mass, spring constant, amplitude, gravity, pendulum length
- Full Khmer localization

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Simulation Rendering | Flame Engine |
| State Management | Riverpod |
| Localization | Flutter l10n (ARB files) |
| Persistence | shared_preferences |

## Project Structure

```
lib/physics/simple_harmonic_motion/
├── app.dart                              # Standalone app entry
├── main.dart                             # Main entry
├── lessons/
│   ├── models/lesson.dart                # Lesson, LessonStep, QuizQuestion models
│   ├── lesson_data.dart                  # Lesson & quiz content
│   └── screens/
│       ├── home_screen.dart              # Module home — lessons + sim + quiz
│       ├── lesson_screen.dart            # Paged lesson viewer
│       └── quiz_screen.dart              # Quiz with scoring
├── game/
│   ├── shm_game.dart                     # Flame game engine
│   ├── physics/
│   │   ├── shm_engine.dart               # Core SHM physics
│   │   ├── spring_engine.dart            # Spring-mass numerical solver
│   │   └── pendulum_engine.dart          # Pendulum numerical solver
│   └── components/
│       ├── spring_component.dart
│       ├── mass_component.dart
│       ├── pendulum_bob_component.dart
│       ├── pendulum_rod_component.dart
│       ├── equilibrium_line_component.dart
│       ├── vector_arrow_component.dart
│       ├── graph_component.dart
│       └── energy_bar_component.dart
├── providers/
│   └── sim_provider.dart                 # Riverpod state
└── ui/
    ├── sim_screen.dart                   # Simulation screen
    ├── control_panel.dart                # Parameter sliders
    └── info_panel.dart                   # Live readouts
```

---

# 〰️ Wave Lab
### Interactive Wave Physics Simulation — Flutter App

### Prerequisites
- Flutter SDK 3.x or higher
- Dart 3.x
- Android Studio or Xcode
- A physical device for IAP testing (emulators do not support Google Play Billing)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/wave_lab.git
cd wave_lab

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

### Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  go_router: ^14.0.0
  fl_chart: ^0.68.0
  flame: ^1.18.0
  in_app_purchase: ^3.2.0
  shared_preferences: ^2.3.0
  flutter_soloud: ^2.0.0
```

### IAP Setup

Before testing purchases you need to:

1. Create an app listing in **Google Play Console** and/or **App Store Connect**
2. Create an In-App Product with ID: `wave_lab_pro` at price $3.99
3. Set status to **Active**
4. Add your Gmail as an internal tester in Play Console
5. Install the app via the internal testing link (not direct `flutter run`)

> IAP does not work on emulators. Always test on a real device signed into a Google Account.

---

## Design System

Wave Lab uses the **Holographic Ocean Lab** design language — an evolution of Ballista's Holographic Lab style adapted for wave physics.

```
Background    #040D17   Deep navy
Primary       #00E5FF   Cyan
Secondary     #00BCD4   Teal
Accent        #64FFDA   Mint
Amber         #FFD740   Highlights
```

Key UI patterns (shared with Ballista):
- `_GlassPanel` — frosted glass card with cyan border glow
- `_HudTag` — split pill system status indicator
- `_GridPainter` — full-screen subtle holographic grid
- `_ParticlePainter` — drifting ambient particles
- `ProGate` — wraps any feature behind the paywall
- `MathSolverOverlay` — bottom sheet with section cards and syntax highlighting

---

## Monetisation

Wave Lab uses a **one-time non-consumable IAP** — no subscription, no ads, no account required.

- Price: **$3.99**
- Product ID: `wave_lab_pro`
- Platform: Google Play Billing + Apple StoreKit (via `in_app_purchase` package)
- Storage: Purchase receipt stored by Google/Apple, unlock flag stored locally via `shared_preferences`
- Restore: Works automatically — tied to Google Account or Apple ID, not the device

The Maths Derivation Module is the primary Pro hook. It is the feature that converts free users — especially students the night before an exam.

---

## Contributing

This is a solo developer project. Issues and suggestions welcome via GitHub Issues.

If Wave Lab has helped you study, consider supporting development:

☕ [Buy Me a Coffee](https://buymeacoffee.com/YOUR_USERNAME)

---

## Related App

**Ballista — Projectile Motion Lab**
The sister app. Same design system, same educational approach, applied to projectile physics.

- 8 projectiles with real physical properties
- Air resistance, multi-planet gravity
- Maths Derivation Module
- Challenge Mode

---

## Licence

MIT Licence. See `LICENSE` for details.

---

*Wave Lab — Physics at your fingertips.*
