import 'package:flutter/material.dart';

class MathsDerivationSheet extends StatelessWidget {
  const MathsDerivationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF040D17),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text(
                      'Mathematical Derivations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _section(
                      '1. The Wave Equation',
                      'The general equation for a sinusoidal wave traveling in the positive x-direction is:',
                      'y(x, t) = A sin(kx - ωt + φ)',
                    ),
                    _section(
                      '2. Particle Velocity',
                      'The velocity of a particle in the medium is the rate of change of its displacement with respect to time:',
                      'v_y = ∂y/∂t = -Aω cos(kx - ωt + φ)',
                    ),
                    _section(
                      '3. Particle Acceleration',
                      'The acceleration is the rate of change of velocity:',
                      'a_y = ∂v_y/∂t = -Aω² sin(kx - ωt + φ)',
                    ),
                    _section(
                      '4. Standing Waves',
                      'Formed by the superposition of two waves of equal amplitude and frequency traveling in opposite directions:',
                      'y(x, t) = [2A sin(kx)] cos(ωt)',
                    ),
                    const Divider(color: Colors.white12, height: 40),
                    const Text(
                      'Key Variables',
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _variable('A', 'Amplitude (peak displacement)'),
                    _variable('k', 'Wave Number (2π/λ)'),
                    _variable('ω', 'Angular Frequency (2πf)'),
                    _variable('φ', 'Phase Constant'),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title, String description, String formula) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              formula,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _variable(String symbol, String meaning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              symbol,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(
              meaning,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
