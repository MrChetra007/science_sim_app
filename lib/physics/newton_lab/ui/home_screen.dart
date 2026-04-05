import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import '../../../core/services/subscription_service.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/ad_widgets.dart';
import '../../../core/widgets/plan_picker.dart';
import '../core/constants.dart';
import '../walkthrough/newton_lab_walkthrough.dart';
import 'widgets/scene_card.dart';
import '../scenes/law1/law1_screen.dart';
import '../scenes/law2/law2_screen.dart';
import '../scenes/law3/law3_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWalkthrough = false;
  final GlobalKey _law1Key = GlobalKey();
  final GlobalKey _law2Key = GlobalKey();
  final GlobalKey _law3Key = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyNewtonLab,
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
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);

    Widget content = Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: AppColors.background),
          // Grid lines
          CustomPaint(painter: GridPainter(), child: Container()),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white70),
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                        ),
                        IconButton(
                          icon: Icon(Icons.stars, color: sub.isPro ? Colors.amber : Colors.white24),
                          onPressed: () => showGlobalPlanDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "NewtonLab",
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primaryAccent),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Interactive Physics Simulator",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SceneCard(
                      walkthroughKey: _law1Key,
                      title: "Law 1: Inertia",
                      tagline: "Explore Friction and Motion",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Law1Screen(),
                          ),
                        );
                      },
                    ),
                    SceneCard(
                      walkthroughKey: _law2Key,
                      title: "Law 2: F = ma",
                      tagline: "Force, Mass, and Acceleration",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Law2Screen(),
                          ),
                        );
                      },
                    ),
                    SceneCard(
                      walkthroughKey: _law3Key,
                      title: "Law 3: Action & Reaction",
                      tagline: "Collisions and Rocket Propulsion",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Law3Screen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    const GlobalBannerAdWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (_showWalkthrough) {
      return NewtonLabWalkthrough(
        onComplete: _completeWalkthrough,
        law1Key: _law1Key,
        law2Key: _law2Key,
        law3Key: _law3Key,
        proKey: _proKey,
        child: content,
      );
    }

    return content;
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gridLines
      ..strokeWidth = 1;

    const double spacing = 40.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
