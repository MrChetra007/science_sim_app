import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart' as p;
import '../../core/widgets/ad_widgets.dart';
import '../../core/widgets/plan_picker.dart';
import '../../core/services/subscription_service.dart';
import '../../core/services/walkthrough_service.dart';
import 'walkthrough/wave_lab_walkthrough.dart';

import 'screens/simulation_screen.dart';
import 'screens/formula_reference_screen.dart';
import 'screens/challenge_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    p.MultiProvider(
      providers: [],
      child: MaterialApp(home: HomeScreen()),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showWalkthrough = false;

  final GlobalKey _enterLabKey = GlobalKey();
  final GlobalKey _formulaKey = GlobalKey();
  final GlobalKey _challengeKey = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyWaveLab,
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      backgroundColor: const Color(0xFF040D17),
      body: Stack(
        children: [
          // Background Animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: HomeScreenPainter(progress: _controller.value),
                size: Size.infinite,
              );
            },
          ),

          // Content
          Column(
            children: [
              const GlobalBannerAdWidget(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFF00E5FF,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '〰️ WAVE LAB',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF00E5FF),
                                letterSpacing: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      _mainButton(
                        key: _enterLabKey,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SimulationScreen(),
                          ),
                        ),
                        label: 'ENTER LAB',
                        icon: Icons.science_outlined,
                      ),
                      const SizedBox(height: 16),
                      _mainButton(
                        key: _formulaKey,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const FormulaReferenceScreen(),
                          ),
                        ),
                        label: 'FORMULA REFERENCE',
                        icon: Icons.menu_book,
                        isSecondary: true,
                      ),
                      const SizedBox(height: 16),
                      _mainButton(
                        key: _challengeKey,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChallengeScreen(),
                          ),
                        ),
                        label: 'CHALLENGE MODE',
                        icon: Icons.emoji_events_outlined,
                        isSecondary: true,
                      ),
                    ],
                  ),
                ),
              ),
              const GlobalBannerAdWidget(),
              const SizedBox(height: 60), // Space for version info
            ],
          ),

          // Bottom Version Info
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: p.Consumer<SubscriptionService>(
                builder: (context, sub, child) => GestureDetector(
                  key: _proKey,
                  onTap: () => showGlobalPlanDialog(context),
                  child: Text(
                    'v1.0.1 ${sub.isPro ? 'SCIENTIFIC PRO' : 'STARTER LAB'}',
                    style: const TextStyle(
                      color: Colors.white24,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (_showWalkthrough) {
      return WaveLabWalkthrough(
        onComplete: _completeWalkthrough,
        enterLabKey: _enterLabKey,
        formulaKey: _formulaKey,
        challengeKey: _challengeKey,
        proKey: _proKey,
        child: content,
      );
    }

    return content;
  }

  Widget _mainButton({
    Key? key,
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    bool isSecondary = false,
  }) {
    final color = isSecondary ? Colors.white70 : const Color(0xFF00E5FF);
    return SizedBox(
      key: key,
      width: 260,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isSecondary
              ? Colors.transparent
              : color.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}

class HomeScreenPainter extends CustomPainter {
  final double progress;
  HomeScreenPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerY = size.height * 0.7;
    final path = Path();

    // Draw 3 layered waves
    for (int wave = 0; wave < 3; wave++) {
      paint.color = const Color(
        0xFF00E5FF,
      ).withValues(alpha: 0.05 + (wave * 0.05));
      path.reset();

      for (double x = 0; x <= size.width; x += 5) {
        final double angle =
            (x / size.width) * 4 * pi + (progress * 2 * pi * (wave + 1));
        final double y = centerY + sin(angle) * (40 + wave * 20);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(HomeScreenPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
