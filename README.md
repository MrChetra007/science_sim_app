# Science Lab - Virtual Experiment Suite

An interactive Flutter application featuring Physics and Chemistry simulations for education. Freemium model with ads and Pro unlock via in-app purchase.

---

## Features

- Interactive simulations with real-time physics calculations
- Step-by-step maths derivations with live substituted values
- Flame game engine for particle animations and interactive components
- fl_chart for data visualization (oscilloscope, pH curves, trajectory graphs)
- Pro unlock (lifetime $4.99 / monthly $0.99) via in-app purchase
- Google Mobile Ads (banners, interstitials, rewarded ads)
- Temporary premium access via rewarded ads (watch 2 ads = 10 min)
- Walkthrough tutorials for every lab
- Localization: English + Khmer
- Dark holographic UI with Orbitron font, frosted glass panels, cyan glow
- Send feedback via EmailJS integration

---

## Physics Labs

| Lab | Description | Key Features |
|-----|-------------|--------------|
| **NewtonLab** | Newton's Laws of Motion — inertia, F=ma, action-reaction | Physics engine with collision resolver, force arrows, friction models, particle effects, 3 law-specific scenes (Law1, Law2, Law3 with Flame game) |
| **OhmLab** | Circuit simulation | Interactive resistance/voltage sliders, electron particle animations (Flame), Ohm's law formula triangle, power bar, readout panel, learn screen |
| **Projectile Motion** | Kinematics simulation | 8 projectiles with real physical properties, 4 planets (Earth, Moon, Mars, Jupiter), air resistance toggle, trajectory graphs, math solver overlay with step-by-step derivations, challenge mode, audio service |
| **AC Lab** | Alternating Current electricity | Real-time voltage/current sine wave, rotating phasor diagram, animated wire with electrons, glowing bulb, transformer with primary/secondary coils, RLC reactive circuits (impedance, phase angle), oscilloscope with V/Div & T/Div, walkthrough |
| **Wave Lab** | Wave mechanics | Transverse, longitudinal, standing waves (n=1..6), interference (constructive/destructive), Doppler effect (moving source), live wave equation HUD, oscilloscope panel, vector overlay, formula reference screen, challenge mode, audio tone generator |
| **SHM Lab** | Simple Harmonic Motion | 4 structured lessons, quiz, interactive spring-mass & pendulum simulation (Flame), real-time position/velocity/acceleration graphs, energy bars, vector overlays |
| **EM Induction Lab** | Electromagnetic Induction | 4 structured lessons (Faraday's Law, Lenz's Law), quiz, interactive magnet-and-coil simulation (Flame), real-time EMF/flux oscilloscope, live formula panel, drag magnet manually |
| **Thermo Lab** | Thermodynamics | Gas laws (Boyle, Charles, Gay-Lussac), heat transfer, phase changes, Carnot engine, entropy explorer, thermo laws |

---

## Chemistry Labs

| Lab | Description | Key Features |
|-----|-------------|--------------|
| **pH Lab** | pH scale and acid-base chemistry | pH explorer with animated beaker, acid-base titration with Flame game engine, pH curve chart (fl_chart), particle system for liquid animation, quiz mode |
| **Atomic & Molecular** | Atomic structure and molecules | Bohr model with animated electron shells (excite electrons), electron configuration builder (Hund's rule, orbital filling), 3D molecule viewer (8 molecules), VSEPR geometry renderer (7 shapes), orbital viewer (s, p, d, f animations). 36 elements. GoRouter navigation. |
| **Electrochemistry** | Electrochemical cells | Galvanic cells, electrolysis with gas readout, Nernst equation calculator with chart, electroplating |

---

## Architecture

```
lib/
├── main.dart                          # App entry, service init, MainDashboard
├── core/
│   ├── services/
│   │   ├── ad_service.dart            # Google Mobile Ads (banner, interstitial, rewarded)
│   │   ├── iap_service.dart           # In-app purchase stream & restore
│   │   ├── subscription_service.dart  # Plan management (free/monthly/lifetime)
│   │   ├── walkthrough_service.dart   # Walkthrough persistence
│   │   ├── feedback_service.dart      # EmailJS feedback
│   │   └── locale_provider.dart       # English/Khmer locale
│   ├── widgets/
│   │   ├── plan_picker.dart           # Subscription dialog
│   │   ├── ad_widgets.dart            # Banner ad widget
│   │   ├── feedback_dialog.dart       # Feedback modal
│   │   └── walkthrough_tooltip.dart   # Overlay tooltip
│   └── screens/
│       └── global_onboarding_screen.dart  # First-launch onboarding (4 pages)
├── physics/
│   ├── newton_lab/                    # Newton's Laws (Flame game engine)
│   ├── ohm_lab/                       # Circuit simulation (Flame)
│   ├── projectile_motion/             # Kinematics (Provider state)
│   ├── ac_lab/                        # AC electricity (Flame + Provider)
│   ├── wave_lab/                      # Wave mechanics (Riverpod + CustomPainter)
│   ├── simple_harmonic_motion/        # SHM lessons, quiz & simulation (Flame + Riverpod)
│   ├── electromagnetic_induction/     # EM Induction lessons, quiz & simulation (Flame + Riverpod)
│   └── thermo_lab/                    # Thermodynamics
└── chemistry/
    ├── acide_base_ph/                 # pH & titration (Flame)
    ├── atomic_molecular/              # Atoms, molecules, VSEPR (Riverpod + GoRouter)
    └── electrochemistry/              # Galvanic cells, Nernst
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.x (Dart 3.x SDK) |
| State Management | Riverpod + Provider |
| Game Engine | Flame 1.18 |
| Charts | fl_chart 0.69 |
| Routing | GoRouter (chemistry labs) |
| Ads | google_mobile_ads 5.1 |
| IAP | in_app_purchase 3.2 |
| Fonts | Google Fonts (Orbitron) |
| Animations | flutter_animate 4.5 |
| Audio | audioplayers 6.1 + flame_audio 2.1 |
| Persistence | shared_preferences |
| Feedback | emailjs |
| CI | GitHub (lint + test workflows) |

---

## Monetization

| Plan | Price | Features |
|------|-------|----------|
| Free | $0 | All labs basic access, banner ads, some features gated |
| Monthly | $0.99/mo | Remove ads, unlock Pro features |
| Lifetime | $4.99 | Remove ads, unlock Pro features, permanent |
| Trial | 2 rewarded ads | 10 minutes of premium access |

Pro-gated features include: maths derivations, advanced wave modes, oscilloscope, audio tone generator, challenge modes, etc.

---

## Running

```bash
flutter pub get
flutter run
```

---

## Project

- **Name:** Science Lab
- **Version:** 1.0.0+14
- **Platforms:** Android, iOS, Web, Windows, Linux, macOS
- **Repository:** https://github.com/mrchetra007
