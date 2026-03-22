import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/iap_service.dart';
import 'services/ad_service.dart';
import 'screens/simulation_screen.dart';
import 'screens/formula_reference_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/challenge_help_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SoLoud.instance.init();
    await iapService.init();
    await adService.init();
  } catch (e) {
    debugPrint('Service initialization failed: $e');
  }

  runApp(const ProviderScope(child: PhysicsShotApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/simulate',
      builder: (context, state) => const SimulationScreen(),
    ),
    GoRoute(
      path: '/formula-reference',
      builder: (context, state) => const FormulaReferenceScreen(),
    ),
    GoRoute(
      path: '/challenge',
      builder: (context, state) => const ChallengeScreen(),
    ),
    GoRoute(
      path: '/challenge-help',
      builder: (context, state) => const ChallengeHelpScreen(),
    ),
  ],
);

class PhysicsShotApp extends StatelessWidget {
  const PhysicsShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WaveLab',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF040D17),
        primaryColor: const Color(0xFF00E5FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  BannerAd? _topBannerAd;
  BannerAd? _bottomBannerAd;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Show interstitial ad every 2 minutes for free users
    Timer.periodic(const Duration(minutes: 2), (timer) {
      if (!iapService.isPro) {
        adService.showInterstitialAd();
      }
    });

    if (!iapService.isPro) {
      _topBannerAd = adService.createBannerAd();
      _bottomBannerAd = adService.createBannerAd();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (!iapService.isPro && _topBannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _topBannerAd!.size.width.toDouble(),
                  height: _topBannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _topBannerAd!),
                ),
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
                            color:
                                const Color(0xFF00E5FF).withValues(alpha: 0.3),
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
                        onPressed: () => context.push('/simulate'),
                        label: 'ENTER LAB',
                        icon: Icons.science_outlined,
                      ),
                      const SizedBox(height: 16),
                      _mainButton(
                        onPressed: () => context.push('/formula-reference'),
                        label: 'FORMULA REFERENCE',
                        icon: Icons.menu_book,
                        isSecondary: true,
                      ),
                      const SizedBox(height: 16),
                      _mainButton(
                        onPressed: () => context.push('/challenge'),
                        label: 'CHALLENGE MODE',
                        icon: Icons.emoji_events_outlined,
                        isSecondary: true,
                      ),
                    ],
                  ),
                ),
              ),
              if (!iapService.isPro && _bottomBannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bottomBannerAd!.size.width.toDouble(),
                  height: _bottomBannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bottomBannerAd!),
                ),
              const SizedBox(height: 60), // Space for version info
            ],
          ),

          // Bottom Version Info
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onLongPress: () async {
                  await iapService.toggleProStatus();
                  setState(() {});
                },
                child: Text(
                  'v1.0.0 ${iapService.isPro ? 'PRO ENABLED' : 'FREE'}',
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    bool isSecondary = false,
  }) {
    final color = isSecondary ? Colors.white70 : const Color(0xFF00E5FF);
    return SizedBox(
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
