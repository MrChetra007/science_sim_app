# Science Lab - Virtual Experiment Suite

An interactive Flutter application featuring Physics and Chemistry simulations for education.

## Labs

### Physics Labs
| Lab | Description |
|-----|-------------|
| **NewtonLab** | Newton's Laws of Motion - explore inertia, F=ma, and action-reaction with physics simulations |
| **OhmLab** | Circuit simulation with interactive resistance, voltage controls, and electron particle animations |
| **Projectile Motion** | Ballista simulation with 8 projectiles, 4 planets, air resistance, and trajectory graphs |
| **AC Lab** | Alternating current visualization - oscilloscope, transformer, and RLC reactive circuits |
| **Wave Lab** | Wave mechanics - transverse, longitudinal, standing waves, interference, and Doppler effect |

### Chemistry Labs
| Lab | Description |
|-----|-------------|
| **pH Lab** | pH scale explorer, acid-base titration, and pH quiz |
| **Atomic & Molecular** | Bohr model, electron configuration, 3D molecule viewer, VSEPR shapes, and orbital visualization |
| **Electrochemistry** | Galvanic cells, electrolysis, Nernst equation, and electroplating |

## Architecture

- **State Management**: Riverpod + Provider
- **Navigation**: go_router + MaterialPageRoute
- **Game Engine**: Flame (for animations)
- **Charts**: fl_chart

## Dependencies

```yaml
flutter_riverpod: ^2.5.1
go_router: ^13.2.0
flame: ^1.18.0
fl_chart: ^0.69.0
flutter_animate: ^4.5.0
google_mobile_ads: ^5.1.0
in_app_purchase: ^3.2.0
google_fonts: ^6.2.1
```

## Running

```bash
flutter pub get
flutter run
```

## Structure

```
lib/
├── main.dart
├── core/           # Shared services (ads, subscriptions, iap)
├── physics/        # Physics lab modules
│   ├── newton_lab/
│   ├── ohm_lab/
│   ├── projectile_motion/
│   ├── ac_lab/
│   └── wave_lab/
└── chemistry/       # Chemistry lab modules
    ├── acide_base_ph/
    ├── atomic_molecular/
    └── electrochemistry/
```

## Monetization

Freemium model with:
- Free tier with ads and limited features
- Monthly subscription ($0.99)
- Lifetime purchase ($4.99)
- Rewarded ads for temporary premium access
