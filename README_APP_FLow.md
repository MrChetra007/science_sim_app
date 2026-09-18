# 🔬 Science Lab

### Interactive Physics & Chemistry Simulations — Flutter App

> **A pocket science lab: hundreds of live, interactive simulations across physics and chemistry — each with step-by-step maths showing *why* every formula works.**

---

## What Is This?

Science Lab is a multi-lab simulation app for **Android** (iOS planned later), built with Flutter. It bundles **11 physics labs and 3 chemistry labs** into one app, letting students and educators visualise everything from Newton's laws to wave interference to chemical titration — live, interactive, and beautiful.

The unifying philosophy across every lab: _don't just show the answer, show the why._ Each lab pairs a real-time simulation with lessons, quizzes, and live formula readouts that substitute your actual values into the maths.

---

## 📋 Simulation Topics (all labs)

### ⚛️ Physics Labs

| Lab | Simulations / Topics |
| --- | --- |
| **Wave Lab** `〰️` | Transverse & longitudinal waves, travelling wave propagation, standing waves (harmonic n=1–6), interference (constructive/destructive), Doppler effect, wave media presets (air/water/steel/vacuum), damping/attenuation, vector overlays |
| **Projectile Motion Lab** `🏹` (Ballista) | 8 projectiles with real physical properties, air resistance, multi-planet gravity, trajectory targeting, maths derivation module |
| **Newton Lab** `🍎` | Newton's 3 Laws scenes: Law 1 (inertia), Law 2 (F = ma), Law 3 (action–reaction), plus friction and collision resolution with force vectors |
| **Ohm Lab** `⚡` | Ohm's Law circuit simulator, voltage/current/resistance control, series & parallel resistance, power readouts, learn mode |
| **AC Lab** `🔌` | AC waveform generator & phasor diagrams, transformer simulation, reactive (impedance) circuits, AC-vs-DC comparison, oscilloscope |
| **Thermo Lab** `🌡️` | Laws of thermodynamics, heat transfer (conduction / convection / radiation), phase change & heating curves, ideal gas laws (PV=nRT) with pV charts, Carnot engine cycle, entropy |
| **SHM Lab** `〰️` | Simple Harmonic Motion: spring–mass & pendulum simulators, position/velocity/acceleration graphs, kinetic & potential energy bars, lessons + quiz |
| **EM Induction Lab** `🧲` | Faraday's Law magnet–coil simulator, Lenz's Law direction logic, EMF/flux oscilloscope, drag-to-move magnet, auto-oscillation |
| **Special Relativity Lab** `⏱️` | Time dilation, length contraction, mass–energy (E = mc²), simultaneity — each with a Lorentz-transformation engine |
| **Optics Lab** `🔦` | Plane mirror reflection, concave/convex mirrors, refraction & total internal reflection, thin lenses, prism dispersion — with ray-tracing Flame simulators, lessons + quiz |
| *(Core)* | Shared holographic design system, Pro gate, global ads & IAP |

### 🧪 Chemistry Labs

| Lab | Simulations / Topics |
| --- | --- |
| **pH & Acid-Base Lab** `🧪` | pH explorer with real substances & indicators, strong/weak acid–base behaviour, acid-base titration with live pH curve |
| **Atomic & Molecular Lab** `⚛️` | Bohr model of the atom, electron configuration & orbital filling, 3D orbital viewer, interactive molecule viewer, VSEPR molecular geometry (linear to octahedral) |
| **Electrochemistry Lab** `🔋` | Galvanic (voltaic) cell with electrode selector & voltmeter, electrolysis of solutions with bubble simulation, electroplating with Faraday's Law, Nernst equation & cell potential |

---

## Features (shared across labs)

- **Real-time interactive simulations** — maple sliders to change parameters, watch the physics update live at 60fps
- **Live formula HUDs** — equations update with your actual values in real time (e.g. y(x,t) = A sin(kx − ωt), V = IR, E = mc²)
- **Step-by-step maths modules** — plain-English derivations of every core formula
- **Lessons & quizzes** — structured lessons with pass/fail quizzes in each lab
- **Graphs & oscilloscopes** — fl_chart powered waveform, pV, EMF, and titration plot graphs
- **Challenge mode & ghost/comparison mode** — interactive learning goals
- **Full Khmer localization** plus English

---

## Monetisation

Science Lab uses a **subscription / one-time lifetime model**:

- **Free** users get core simulations and can watch **rewarded ads** for short-term Pro access
- Rewarded-ads, interstitial ads, and banners appear for **free users only** — any active plan removes all ads

| Tier | Ads | Pro features / all labs |
| --- | :---: | :---: |
| Free | Shown | ✗ (rewarded-ad trials available) |
| Monthly / Lifetime | None | ✓ (all labs & features unlocked) |

---

## Tech Stack

| Layer | Technology |
| --- | --- |
| Framework | Flutter 3.x — Android-first |
| Simulation Rendering | Flame Engine + CustomPainter (canvas, 60fps) |
| State Management | Riverpod + Provider |
| Graphs | fl_chart |
| Ads (AdMob) | google_mobile_ads — banner / interstitial / rewarded |
| Payments | in_app_purchase — subscription + lifetime |
| Persistence | shared_preferences |
| Localization | Flutter l10n (ARB files) — EN + KM |

---

## Modules & Project Structure

```
lib/
├── main.dart                    # Science Lab app shell — routes all labs
├── core/                        # Shared: ads, IAP, subscription, plan picker, Pro gate
├── physics/
│   ├── wave_lab/                # Wave Lab
│   ├── projectile_motion/       # Ballista — Projectile Motion
│   ├── newton_lab/              # Newton's Laws (3 scenes + friction/collisions)
│   ├── ohm_lab/                 # Ohm's Law circuits
│   ├── ac_lab/                  # AC electricity (transformer, reactive, oscilloscope)
│   ├── thermo_lab/              # Thermo laws, heat transfer, phase change, gas laws, Carnot, entropy
│   ├── simple_harmonic_motion/  # SHM — spring-mass & pendulum
│   ├── electromagnetic_induction/ # Faraday / Lenz
│   ├── special_relativity/      # Time dilation, length contraction, mass-energy, simultaneity
│   └── optic_lab/               # Plane/curved mirrors, refraction, lenses, dispersion
└── chemistry/
    ├── acide_base_ph/           # pH explorer + titration
    ├── atomic_molecular/        # Bohr, electron config, orbitals, molecules, VSEPR
    └── electrochemistry/        # Galvanic cell, electrolysis, electroplating, Nernst
```

---

## Building & Running

```bash
# Requirements
#   Flutter 3.47.x   (Gradle ≥ 8.14, AGP ≥ 8.11.1, Kotlin ≥ 2.2.20)

flutter pub get
flutter run                     # debug
flutter build appbundle --release   # release for Play Store
```

### Android release build notes

- Target SDK / compile SDK 36, minSdk 24+
- `gradle/wrapper/gradle-wrapper.properties` → Gradle 8.14.0
- `android/settings.gradle.kts` → AGP 8.11.1, Kotlin 2.2.20
- Config your **AdMob** app + ad unit IDs and **Play Billing** products (`subscription_0.99`, `sozin.wave`) in Play Console before release

---

## Licence

MIT Licence. See `LICENSE` for details.

---

_Science Lab — Physics & chemistry at your fingertips._
