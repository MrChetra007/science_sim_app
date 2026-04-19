import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import '../../../core/services/subscription_service.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../core/widgets/ad_widgets.dart';
import '../walkthrough/projectile_motion_walkthrough.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _arcController;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;
  late final AnimationController _radarController;
  late final Animation<double> _arcAnimation;
  late final Animation<double> _pulseAnimation;
  final List<_Particle> _particles = [];
  bool _showWalkthrough = false;

  final GlobalKey _launchButtonKey = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _arcController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _radarController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
    _arcAnimation =
        CurvedAnimation(parent: _arcController, curve: Curves.easeInOut);
    _pulseAnimation =
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    final rng = math.Random(42);
    for (int i = 0; i < 55; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 2.2 + 0.4,
        speed: rng.nextDouble() * 0.18 + 0.04,
        opacity: rng.nextDouble() * 0.5 + 0.15,
        phase: rng.nextDouble(),
      ));
    }
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyProjectileMotion,
    );
    if (mounted && !shown) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showWalkthrough = true);
      });
    }
  }

  void _completeWalkthrough() {
    setState(() => _showWalkthrough = false);
  }

  @override
  void dispose() {
    _arcController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget content = Scaffold(
      backgroundColor: const Color(0xFF040D17),
      body: Stack(
        children: [
          // ── Full-screen animated particle field ──────────────────────
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, _) => CustomPaint(
              painter: _ParticlePainter(_particles, _particleController.value),
              size: size,
            ),
          ),
          // ── Holographic grid ─────────────────────────────────────────
          CustomPaint(painter: _GridPainter(), size: size),
          // ── Main content ─────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // HUD status bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white70),
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      ),
                      const SizedBox(width: 8),
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (_, _) => Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.lerp(const Color(0xFF00E5FF),
                                const Color(0xFF64FFDA), _pulseAnimation.value),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withValues(
                                    alpha: 0.6 * _pulseAnimation.value + 0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('READY',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color:
                                const Color(0xFF00E5FF).withValues(alpha: 0.7),
                            letterSpacing: 2,
                          )),
                      const Spacer(),
                      p.Consumer<SubscriptionService>(
                        builder: (context, sub, _) => IconButton(
                          key: _proKey,
                          icon: Icon(Icons.stars, color: sub.isPro ? Colors.amber : Colors.white24),
                          onPressed: () => showGlobalPlanDialog(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Arc / radar glass panel
                _GlassPanel(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 190,
                    child: AnimatedBuilder(
                      animation:
                          Listenable.merge([_arcAnimation, _radarController]),
                      builder: (_, _) => CustomPaint(
                        painter: _HoloArcPainter(
                            _arcAnimation.value, _radarController.value),
                        size: const Size(double.infinity, 190),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE0F7FA),
                      Color(0xFF00E5FF),
                      Color(0xFF64FFDA)
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'Physics\nShot',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Subtitle with divider lines
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 28,
                        height: 1,
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
                    const SizedBox(width: 8),
                    Text('PHYSICS AT YOUR FINGERTIPS',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w500,
                          color:
                              const Color(0xFF80DEEA).withValues(alpha: 0.65),
                        )),
                    const SizedBox(width: 8),
                    Container(
                        width: 28,
                        height: 1,
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
                  ],
                ),
                const SizedBox(height: 22),
                // Feature chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _HoloChip(icon: '🎯', label: '8 Projectiles'),
                      _HoloChip(icon: '🪐', label: '4 Planets'),
                      _HoloChip(icon: '💨', label: 'Air Resistance'),
                      _HoloChip(icon: '📊', label: 'Live Graphs'),
                      _HoloChip(icon: '🐢', label: 'Slow Motion'),
                      _HoloChip(icon: '✏️', label: 'Challenge Mode'),
                    ],
                  ),
                ),
                const Spacer(),
                // Stats readout panel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _GlassPanel(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const _StatReadout(label: 'GRAVITY', value: '9.8 m/s²'),
                        _VertDivider(),
                        const _StatReadout(label: 'DRAG', value: '0.47 Cd'),
                        _VertDivider(),
                        const _StatReadout(label: 'ENV', value: 'EARTH'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Pulsing launch button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (_, _) {
                      final glow = 0.25 + _pulseAnimation.value * 0.35;
                      return GestureDetector(
                        key: _launchButtonKey,
                        onTap: () => context.go('/simulation'),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 66,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(33),
                                border: Border.all(
                                  color: const Color(0xFF00E5FF)
                                      .withValues(alpha: glow),
                                  width: 1,
                                ),
                              ),
                            ),
                            Container(
                              height: 58,
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF006778),
                                    Color(0xFF004D5E)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(29),
                                border: Border.all(
                                  color: const Color(0xFF00E5FF)
                                      .withValues(alpha: 0.55),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E5FF)
                                        .withValues(alpha: glow * 0.9),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.rocket_launch_rounded,
                                        color: Color(0xFFE0F7FA), size: 22),
                                    SizedBox(width: 10),
                                    Text('LAUNCH SIMULATOR',
                                        style: TextStyle(
                                          color: Color(0xFFE0F7FA),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const GlobalBannerAdWidget(),
                const SizedBox(height: 10),
                Text('v1.0  ·  PHASE 4',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      letterSpacing: 3,
                      color: Colors.white.withValues(alpha: 0.2),
                    )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );

    if (_showWalkthrough) {
      return ProjectileMotionWalkthrough(
        onComplete: _completeWalkthrough,
        launchButtonKey: _launchButtonKey,
        proKey: _proKey,
        child: content,
      );
    }

    return content;
  }
}

// ─── Painters ────────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.028)
      ..strokeWidth = 0.8;
    const step = 36.0;
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
  const _Particle(
      {required this.x,
      required this.y,
      required this.size,
      required this.speed,
      required this.opacity,
      required this.phase});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  const _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final yPos = ((p.y - p.speed * t + p.phase) % 1.0) * size.height;
      final flicker = math.sin((t + p.phase) * math.pi * 6) * 0.15 + 0.85;
      canvas.drawCircle(
        Offset(p.x * size.width, yPos),
        p.size,
        Paint()
          ..color =
              const Color(0xFF00E5FF).withValues(alpha: p.opacity * flicker),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

class _HoloArcPainter extends CustomPainter {
  final double progress;
  final double radarAngle;
  const _HoloArcPainter(this.progress, this.radarAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Radar sweep
    final rc = Offset(w * 0.07 + 10, h - 22);
    final rr = h * 0.75;
    final sa = radarAngle * 2 * math.pi;
    canvas.drawCircle(
        rc,
        rr,
        Paint()
          ..shader = SweepGradient(
            colors: [
              Colors.transparent,
              const Color(0xFF00E5FF).withValues(alpha: 0.12)
            ],
            transform: GradientRotation(sa - 0.6),
            startAngle: sa - 0.6,
            endAngle: sa,
          ).createShader(Rect.fromCircle(center: rc, radius: rr)));
    canvas.drawCircle(
        rc,
        rr,
        Paint()
          ..color = const Color(0xFF00E5FF).withValues(alpha: 0.06)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8);

    // Ground
    canvas.drawLine(
        Offset(0, h - 22),
        Offset(w, h - 22),
        Paint()
          ..color = const Color(0xFF00E5FF).withValues(alpha: 0.25)
          ..strokeWidth = 1);

    // Arc
    final path = Path();
    bool started = false;
    for (int i = 0; i <= 80; i++) {
      final t = i / 80;
      if (t > progress) break;
      final x = t * w * 0.86 + w * 0.07;
      final nx = (x - w * 0.07) / (w * 0.86);
      final ay = h - 22 - (h - 44) * 4 * nx * (1 - nx);
      started ? path.lineTo(x, ay) : path.moveTo(x, ay);
      started = true;
    }

    if (started) {
      canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0x1800E5FF)
            ..strokeWidth = 20
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
      canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0x4400E5FF)
            ..strokeWidth = 7
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      canvas.drawPath(
          path,
          Paint()
            ..shader = LinearGradient(
              colors: [const Color(0xFF64FFDA), const Color(0xFF00E5FF)],
            ).createShader(Rect.fromLTWH(0, 0, w, h))
            ..strokeWidth = 2.2
            ..style = PaintingStyle.stroke);

      // Tip dot
      final tx = progress.clamp(0.0, 1.0) * w * 0.86 + w * 0.07;
      final tnx = (tx - w * 0.07) / (w * 0.86);
      final ty = h - 22 - (h - 44) * 4 * tnx * (1 - tnx);
      canvas.drawCircle(
          Offset(tx, ty),
          18,
          Paint()
            ..color = const Color(0x1500E5FF)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
      canvas.drawCircle(
          Offset(tx, ty),
          9,
          Paint()
            ..color = const Color(0x7700E5FF)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      canvas.drawCircle(Offset(tx, ty), 5, Paint()..color = Colors.white);
      canvas.drawCircle(
          Offset(tx, ty), 3.5, Paint()..color = const Color(0xFF00E5FF));
    }

    // Cannon
    final cp = Offset(w * 0.07, h - 22);
    canvas.drawCircle(
        cp,
        12,
        Paint()
          ..color = const Color(0xFF37474F)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(cp, 10, Paint()..color = const Color(0xFF546E7A));
    canvas.drawCircle(
        cp,
        10,
        Paint()
          ..color = const Color(0xFF00E5FF).withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    canvas.save();
    canvas.translate(cp.dx, cp.dy);
    canvas.rotate(-math.pi / 4);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(0, -5.5, 40, 11), const Radius.circular(4)),
        Paint()..color = const Color(0xFF37474F));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(0, -5.5, 40, 11), const Radius.circular(4)),
        Paint()
          ..color = const Color(0xFF00E5FF).withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HoloArcPainter old) =>
      old.progress != progress || old.radarAngle != radarAngle;
}

// ─── UI Components ────────────────────────────────────────────────────────────

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const _GlassPanel({required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.18), width: 1),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.05),
              blurRadius: 20)
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}

class _HudTag extends StatelessWidget {
  final String label, value;
  const _HudTag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const ts =
        TextStyle(fontFamily: 'monospace', fontSize: 9, letterSpacing: 1.5);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.18),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
        ),
        child: Text(label, style: ts.copyWith(color: const Color(0xFF00E5FF))),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.07),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
          border: Border.all(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
              width: 0.5),
        ),
        child: Text(value,
            style: ts.copyWith(
                color: const Color(0xFF80DEEA).withValues(alpha: 0.8))),
      ),
    ]);
  }
}

class _HoloChip extends StatelessWidget {
  final String icon, label;
  const _HoloChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.22), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
              color: Color(0xFF80DEEA),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            )),
      ]),
    );
  }
}

class _StatReadout extends StatelessWidget {
  final String label, value;
  const _StatReadout({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            letterSpacing: 2,
            color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
          )),
      const SizedBox(height: 3),
      Text(value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            letterSpacing: 1,
            color: Color(0xFF80DEEA),
            fontWeight: FontWeight.w700,
          )),
    ]);
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1,
      height: 28,
      color: const Color(0xFF00E5FF).withValues(alpha: 0.15));
}
