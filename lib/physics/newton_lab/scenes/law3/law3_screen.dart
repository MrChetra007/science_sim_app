import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'law3_game.dart';
import '../../core/constants.dart';
import '../../ui/widgets/neon_slider.dart';
import '../../ui/widgets/info_panel.dart';
import '../../../../core/widgets/ad_widgets.dart';

class Law3Screen extends StatefulWidget {
  const Law3Screen({super.key});

  @override
  State<Law3Screen> createState() => _Law3ScreenState();
}

class _Law3ScreenState extends State<Law3Screen>
    with SingleTickerProviderStateMixin {
  late Law3Game game;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  Law3SceneType selectedScene = Law3SceneType.collision;

  double massA = 10.0;
  double massB = 10.0;
  double bounciness = 1.0;

  @override
  void initState() {
    super.initState();
    game = Law3Game();

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
        title: const Text('Law 3: Action & Reaction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: AppColors.background),
          CustomPaint(painter: GridPainter(), child: Container()),

          SafeArea(child: GameWidget(game: game)),

          Positioned(
            top: 80,
            right: 20,
            width: 320,
            child: InfoPanel(
              title: selectedScene == Law3SceneType.collision
                  ? "Collisions"
                  : "Rocket Propulsion",
              description: selectedScene == Law3SceneType.collision
                  ? "When objects collide, they exert equal and opposite forces on each other (Impulse)."
                  : "A rocket expels particles downward (Action), which pushes the rocket upward (Reaction).",
              formula: "F_AB = -F_BA",
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
                          const Text('Demo: '),
                          const SizedBox(width: 8),
                          DropdownButton<Law3SceneType>(
                            value: selectedScene,
                            dropdownColor: AppColors.background,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: Law3SceneType.collision,
                                child: Text('Elastic Collisions'),
                              ),
                              DropdownMenuItem(
                                value: Law3SceneType.rocket,
                                child: Text('Rocket Propulsion'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedScene = value;
                                });
                                game.switchScene(value);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (selectedScene == Law3SceneType.collision) ...[
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
                                    massA,
                                    massB,
                                    bounciness,
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
                                    massA,
                                    massB,
                                    bounciness,
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
                                label:
                                    'Bounciness (e): ${bounciness.toStringAsFixed(2)}',
                                value: bounciness,
                                min: 0,
                                max: 1,
                                onChanged: (val) {
                                  setState(() => bounciness = val);
                                  game.updateParameters(
                                    massA,
                                    massB,
                                    bounciness,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
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
                              game.launch();
                            },
                            child: Text(
                              selectedScene == Law3SceneType.collision
                                  ? 'SIMULATE'
                                  : 'LAUNCH',
                              style: const TextStyle(
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
