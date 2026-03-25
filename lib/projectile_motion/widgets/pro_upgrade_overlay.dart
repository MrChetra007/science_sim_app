import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import 'dart:math' as math;

class ProUpgradeOverlay extends ConsumerStatefulWidget {
  const ProUpgradeOverlay({super.key});

  // ✅ Must live HERE on the widget class — not in the state
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProUpgradeOverlay(),
    );
  }

  @override
  ConsumerState<ProUpgradeOverlay> createState() => _ProUpgradeOverlayState();
}

class _ProUpgradeOverlayState extends ConsumerState<ProUpgradeOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;
  late final AnimationController _particleController;
  late final Animation<double> _pulseAnimation;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _pulseAnimation =
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    final rng = math.Random(7);
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 1.8 + 0.4,
        speed: rng.nextDouble() * 0.15 + 0.03,
        opacity: rng.nextDouble() * 0.4 + 0.1,
        phase: rng.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF040D17),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: const Color(0xFFFFD740).withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD740).withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Stack(
          children: [
            // ── Grid ──────────────────────────────────────────────────
            CustomPaint(
              painter: _GridPainter(),
              size: Size(size.width, size.height * 0.85),
            ),

            // ── Particles ─────────────────────────────────────────────
            AnimatedBuilder(
              animation: _particleController,
              builder: (_, __) => CustomPaint(
                painter: _ParticlePainter(_particles, _particleController.value,
                    color: const Color(0xFFFFD740)),
                size: Size(size.width, size.height * 0.85),
              ),
            ),

            // ── Top amber glow ────────────────────────────────────────
            Positioned(
              top: -60,
              left: size.width * 0.2,
              right: size.width * 0.2,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, __) => Container(
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD740).withValues(
                            alpha: 0.12 + _pulseAnimation.value * 0.08),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Scrollable content ────────────────────────────────────
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (_, __) => Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(top: 14, bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: const Color(0xFFFFD740).withValues(
                            alpha: 0.3 + _pulseAnimation.value * 0.4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD740)
                                .withValues(alpha: 0.3 * _pulseAnimation.value),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── PRO badge ─────────────────────────────────────
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (_, __) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFD740).withValues(alpha: 0.5),
                          width: 1,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFD740).withValues(alpha: 0.08),
                            const Color(0xFFFFD740).withValues(alpha: 0.18),
                            const Color(0xFFFFD740).withValues(alpha: 0.08),
                          ],
                          stops: [
                            0.0,
                            _shimmerController.value,
                            1.0,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 6),
                          Text(
                            'BALLISTA PRO',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: const Color(0xFFFFD740)
                                  .withValues(alpha: 0.9),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Title ─────────────────────────────────────────
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFFD740),
                        Color(0xFFFF8F00),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Unlock the\nFull Lab',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 1,
                        color: const Color(0xFFFFD740).withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ONE-TIME · NO SUBSCRIPTION · FOREVER',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color:
                              const Color(0xFFFFD740).withValues(alpha: 0.45),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 20,
                        height: 1,
                        color: const Color(0xFFFFD740).withValues(alpha: 0.3),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Features glass card ────────────────────────────
                  _GlassCard(
                    borderColor:
                        const Color(0xFFFFD740).withValues(alpha: 0.15),
                    child: Column(
                      children: [
                        _FeatureRow(
                          emoji: '🚀',
                          label: 'ALL PROJECTILES',
                          sub: 'Cannonball, Bowling Ball, Pumpkin + more',
                          color: const Color(0xFF00E5FF),
                        ),
                        _FeatureDivider(),
                        _FeatureRow(
                          emoji: '🪐',
                          label: 'MULTI-PLANET GRAVITY',
                          sub: 'Moon, Mars, Jupiter & Custom 0–30 m/s²',
                          color: const Color(0xFF64FFDA),
                        ),
                        _FeatureDivider(),
                        _FeatureRow(
                          emoji: '💨',
                          label: 'AIR RESISTANCE ENGINE',
                          sub: 'Real drag force with mass & area physics',
                          color: const Color(0xFF80DEEA),
                        ),
                        _FeatureDivider(),
                        _FeatureRow(
                          emoji: '📐',
                          label: 'MATH DERIVATION MODULE',
                          sub: 'Step-by-step live formula derivation',
                          color: const Color(0xFFFFD740),
                        ),
                        _FeatureDivider(),
                        _FeatureRow(
                          emoji: '📊',
                          label: 'VECTOR VISUALIZATIONS',
                          sub: 'Gravity, drag & velocity component arrows',
                          color: const Color(0xFF69FF47),
                        ),
                        _FeatureDivider(),
                        _FeatureRow(
                          emoji: '👻',
                          label: 'GHOST TRAIL COMPARISON',
                          sub: 'Side-by-side variable change analysis',
                          color: const Color(0xFFE040FB),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Pricing + CTA card ────────────────────────────
                  _GlassCard(
                    borderColor:
                        const Color(0xFFFFD740).withValues(alpha: 0.25),
                    child: Column(
                      children: [
                        // Price row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '\$',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFFD740)
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            const Text(
                              '3.99',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'ONE-TIME PURCHASE',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color:
                                const Color(0xFFFFD740).withValues(alpha: 0.5),
                            letterSpacing: 2.5,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // CTA Button
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (_, __) => GestureDetector(
                            onTap: () async {
                              await ref
                                  .read(simulationProvider.notifier)
                                  .unlockPro();
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Pulse ring
                                Container(
                                  height: 62,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(31),
                                    border: Border.all(
                                      color: const Color(0xFFFFD740).withValues(
                                          alpha: 0.2 +
                                              _pulseAnimation.value * 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                // Button
                                Container(
                                  height: 54,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFFFD740),
                                        const Color(0xFFFF8F00),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(27),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFD740)
                                            .withValues(
                                                alpha: 0.3 +
                                                    _pulseAnimation.value *
                                                        0.2),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.lock_open_rounded,
                                            color: Color(0xFF040D17), size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'UNLOCK EVERYTHING',
                                          style: TextStyle(
                                            color: Color(0xFF040D17),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Restore + fine print
                  TextButton(
                    onPressed: () async {
                      await ref.read(simulationProvider.notifier).restorePro();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Restoring purchases...'),
                            backgroundColor: Color(0xFF1E3A4A),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Restore Previous Purchase',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.25),
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  Text(
                    'Restores automatically across all your devices.\nNo account required.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: Colors.white.withValues(alpha: 0.18),
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting widgets
// ─────────────────────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  const _GlassCard({required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD740).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD740).withValues(alpha: 0.04),
            blurRadius: 20,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String sub;
  final Color color;
  const _FeatureRow({
    required this.emoji,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Emoji in a glass badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.45),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          // Check
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: color, size: 13),
          ),
        ],
      ),
    );
  }
}

class _FeatureDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFFFD740).withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painters
// ─────────────────────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD740).withValues(alpha: 0.025)
      ..strokeWidth = 0.7;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _Particle {
  final double x, y, size, speed, opacity, phase;
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  final Color color;
  const _ParticlePainter(this.particles, this.t, {required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final yPos = ((p.y - p.speed * t + p.phase) % 1.0) * size.height;
      final flicker = math.sin((t + p.phase) * math.pi * 6) * 0.15 + 0.85;
      canvas.drawCircle(
        Offset(p.x * size.width, yPos),
        p.size,
        Paint()..color = color.withValues(alpha: p.opacity * flicker),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}
