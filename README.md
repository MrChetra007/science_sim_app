# Science Lab - Virtual Experiment Suite

An interactive Flutter application featuring Physics and Chemistry simulations for education.

## Features

- Interactive simulations with real-time physics calculations
- Step-by-step maths derivations with live values
- Multiple planets/gravity presets
- Flame game engine for animations
- fl_chart for data visualization
- In-app purchases for Pro unlock
- Ads integration

## Labs

### Physics Labs
| Lab | Description |
|-----|-------------|
| **NewtonLab** | Newton's Laws of Motion - explore inertia, F=ma, and action-reaction with physics simulations |
| **OhmLab** | Circuit simulation with interactive resistance, voltage controls, and electron particle animations |
| **Projectile** | Kinematics simulation with multiple projectiles, planets, air resistance, and trajectory graphs |
| **AC Lab** | Alternating current visualization - oscilloscope, transformer, and RLC reactive circuits |
| **Wave Lab** | Wave mechanics - transverse, longitudinal, standing waves, interference, and Doppler effect |
| **Thermo Lab** | Thermodynamics - heat transfer, phase changes, and thermo laws |

### Chemistry Labs
| Lab | Description |
|-----|-------------|
| **pH Lab** | pH scale explorer, acid-base titration, and pH calculations |
| **Atomic & Molecular** | Bohr model, electron configuration, 3D molecule viewer, VSEPR shapes, and orbital visualization |
| **Electrochemistry** | Galvanic cells, electrolysis, Nernst equation, and electroplating |

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod + Provider
- **Game Engine**: Flame
- **Charts**: fl_chart
- **Fonts**: Google Fonts (Orbitron)
- **Ads**: google_mobile_ads
- **IAP**: in_app_purchase

## Running

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── core/                    # Shared services (ads, subscriptions, iap, walkthrough)
│   ├── services/
│   └── widgets/
├── physics/
│   ├── newton_lab/          # Newton's Laws of Motion
│   ├── ohm_lab/             # Circuit simulation
│   ├── projectile_motion/    # Kinematics
│   ├── ac_lab/              # Alternating current
│   ├── wave_lab/            # Wave mechanics
│   └── thermo_lab/          # Thermodynamics
└── chemistry/
    ├── acide_base_ph/        # pH scale
    ├── atomic_molecular/    # Atoms & molecules
    └── electrochemistry/   # Galvanic cells
```

## Monetization

Freemium model with ads and Pro unlock via in-app purchase.
