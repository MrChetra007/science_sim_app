import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormulaScreen extends StatelessWidget {
  const FormulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1520),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.go('/simulation'),
        ),
        title: const Text(
          'Formula Guide',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Section(
            title: 'Kinematic Equations',
            icon: '📐',
            cards: [
              _FormulaCard(
                name: 'Horizontal Position',
                formula: 'x(t) = v₀ · cos(θ) · t',
                description:
                    'Horizontal distance at time t. Constant velocity — no forces act horizontally (without air resistance).',
                color: Color(0xFF00E5FF),
              ),
              _FormulaCard(
                name: 'Vertical Position',
                formula: 'y(t) = h₀ + v₀·sin(θ)·t − ½g·t²',
                description:
                    'Height at time t. The −½g·t² term is the effect of gravity pulling the projectile down.',
                color: Color(0xFF69FF47),
              ),
              _FormulaCard(
                name: 'Horizontal Velocity',
                formula: 'vₓ = v₀ · cos(θ)',
                description:
                    'Constant throughout flight (no horizontal forces without drag).',
                color: Color(0xFF00E5FF),
              ),
              _FormulaCard(
                name: 'Vertical Velocity',
                formula: 'vᵧ(t) = v₀·sin(θ) − g·t',
                description:
                    'Decreases linearly due to gravity. Zero at peak height.',
                color: Color(0xFF69FF47),
              ),
            ],
          ),
          SizedBox(height: 12),
          _Section(
            title: 'Key Results',
            icon: '🎯',
            cards: [
              _FormulaCard(
                name: 'Hang Time',
                formula: 't = (v₀·sin(θ) + √(v₀²sin²(θ) + 2gh₀)) / g',
                description:
                    'Total flight time from launch to landing. Derived from setting y(t) = 0.',
                color: Color(0xFFFFD740),
              ),
              _FormulaCard(
                name: 'Range (no air resistance)',
                formula: 'R = vₓ · t_hang',
                description:
                    'Maximum horizontal distance. For h₀ = 0 and θ = 45°: R = v₀² / g (optimal range).',
                color: Color(0xFFFFD740),
              ),
              _FormulaCard(
                name: 'Max Height',
                formula: 'H = h₀ + v₀²·sin²(θ) / (2g)',
                description:
                    'Peak height above ground. Reached when vᵧ = 0, i.e., at t = v₀·sin(θ) / g.',
                color: Color(0xFFFF80AB),
              ),
              _FormulaCard(
                name: 'Speed at Any Time',
                formula: '|v| = √(vₓ² + vᵧ²)',
                description:
                    'Pythagoras on the velocity components. Minimum at peak (= vₓ), maximum at launch.',
                color: Color(0xFFFF80AB),
              ),
            ],
          ),
          SizedBox(height: 12),
          _Section(
            title: 'Air Resistance (Drag)',
            icon: '💨',
            cards: [
              _FormulaCard(
                name: 'Drag Force',
                formula: 'F_d = ½ · ρ · Cₐ · A · v²',
                description:
                    'ρ = air density (1.225 kg/m³), Cₐ = drag coefficient, A = cross-sectional area, v = speed. Opposes velocity.',
                color: Color(0xFF80DEEA),
              ),
              _FormulaCard(
                name: 'Net Acceleration (with drag)',
                formula: 'aₓ = −Fd·vₓ/(|v|·m)   aᵧ = −g − Fd·vᵧ/(|v|·m)',
                description:
                    'Euler integration: v += a·dt, x += v·dt. Step size dt = 0.02 s.',
                color: Color(0xFF80DEEA),
              ),
            ],
          ),
          SizedBox(height: 12),
          _ConstantsCard(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String icon;
  final List<_FormulaCard> cards;

  const _Section({
    required this.title,
    required this.icon,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...cards,
      ],
    );
  }
}

class _FormulaCard extends StatelessWidget {
  final String name;
  final String formula;
  final String description;
  final Color color;

  const _FormulaCard({
    required this.name,
    required this.formula,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF101F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Text(
              name,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          // Formula box
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formula,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConstantsCard extends StatelessWidget {
  const _ConstantsCard();

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('g (Earth)', '9.81 m/s²', '🌍'),
      ('g (Moon)', '1.62 m/s²', '🌙'),
      ('g (Mars)', '3.72 m/s²', '🔴'),
      ('g (Jupiter)', '24.79 m/s²', '🪐'),
      ('ρ (air, sea level)', '1.225 kg/m³', '💨'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF546E7A).withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Text(
              '⚙️  CONSTANTS',
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          ...rows.map((r) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Row(
                  children: [
                    Text(r.$3, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.$1,
                        style: const TextStyle(
                            color: Color(0xFF80DEEA), fontSize: 12),
                      ),
                    ),
                    Text(
                      r.$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
