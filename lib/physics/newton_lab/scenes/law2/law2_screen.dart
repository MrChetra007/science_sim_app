import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'law2_game.dart';
import '../../core/constants.dart';
import '../../ui/widgets/neon_slider.dart';
import '../../ui/widgets/info_panel.dart';
import '../../../../core/widgets/ad_widgets.dart';

class Law2Screen extends StatefulWidget {
  const Law2Screen({super.key});

  @override
  State<Law2Screen> createState() => _Law2ScreenState();
}

class _Law2ScreenState extends State<Law2Screen>
    with SingleTickerProviderStateMixin {
  late Law2Game game;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  double _appliedForce = 20.0;
  double massA = 10.0;
  double massB = 30.0;

  @override
  void initState() {
    super.initState();
    game = Law2Game();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Law 2: F = ma'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: AppColors.background),
          CustomPaint(painter: GridPainter(), child: Container()),

          SafeArea(child: GameWidget(game: game)),

          const Positioned(
            top: 80,
            right: 20,
            width: 320,
            child: InfoPanel(
              title: "Newton's Second Law",
              description:
                  "The acceleration of an object depends on the mass of the object and the amount of force applied.",
              formula: "F = m × a",
            ),
          ),

          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _slideAnimation,
              child: Card(
                color: AppColors.surface.withValues(alpha: 0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: NeonSlider(
                              label:
                                  'Applied Force: ${_appliedForce.toStringAsFixed(1)} N',
                              value: _appliedForce,
                              min: 1,
                              max: 100,
                              onChanged: (val) {
                                setState(() => _appliedForce = val);
                                game.updateParameters(
                                  _appliedForce,
                                  massA,
                                  massB,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: NeonSlider(
                              label: 'Mass A: ${massA.toStringAsFixed(0)} kg',
                              value: massA,
                              min: 1,
                              max: 50,
                              onChanged: (val) {
                                setState(() => massA = val);
                                game.updateParameters(
                                  _appliedForce,
                                  massA,
                                  massB,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: NeonSlider(
                              label: 'Mass B: ${massB.toStringAsFixed(0)} kg',
                              value: massB,
                              min: 1,
                              max: 50,
                              onChanged: (val) {
                                setState(() => massB = val);
                                game.updateParameters(
                                  _appliedForce,
                                  massA,
                                  massB,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              side: const BorderSide(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            onPressed: () {
                              game.resetSimulation();
                            },
                            child: const Text(
                              'RESET',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent
                                  .withOpacity(0.2),
                              side: const BorderSide(
                                color: AppColors.primaryAccent,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              game.applyForce(_appliedForce);
                            },
                            child: const Text(
                              'APPLY FORCE',
                              style: TextStyle(
                                color: AppColors.primaryAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(child: GlobalBannerAdWidget()),
          ),
        ],
      ),
    );
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
