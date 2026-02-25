import 'package:flutter/material.dart';

class FormulaReferenceScreen extends StatelessWidget {
  const FormulaReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: const Text('Formula Reference'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF00E5FF),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _category('Fundamental Equations'),
          _formula(
            'Wave Speed',
            'v = fλ',
            'v: Velocity (m/s), f: Frequency (Hz), λ: Wavelength (m)',
          ),
          _formula('Period', 'T = 1/f', 'T: Period (s), f: Frequency (Hz)'),
          _formula(
            'Angular Frequency',
            'ω = 2πf',
            'ω: Angular Frequency (rad/s), f: Frequency (Hz)',
          ),
          _formula(
            'Wave Number',
            'k = 2π / λ',
            'k: Wave Number (rad/m), λ: Wavelength (m)',
          ),
          const SizedBox(height: 20),
          _category('Wave Propagation'),
          _formula(
            'Traveling Wave',
            'y(x, t) = A sin(kx - ωt + φ)',
            'y: Displacement, A: Amplitude, x: Position, t: Time',
          ),
          _formula(
            'Standing Wave',
            'y(x, t) = [2A sin(kx)] cos(ωt)',
            'λ_n = 2L / n (for n-th harmonic)',
          ),
          const SizedBox(height: 20),
          _category('Advanced Physics'),
          _formula(
            'Doppler Effect',
            "f' = f [v / (v - v_s)]",
            "f': Observed Frequency, v_s: Source Velocity",
          ),
          _formula(
            'Damped Wave',
            'y(x, t) = A e^{-γx} sin(kx - ωt)',
            'γ: Damping coefficient',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _category(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00E5FF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _formula(String name, String math, String variables) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              math,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 18,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            variables,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
