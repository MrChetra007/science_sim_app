import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'law3_game.dart';
import '../../core/constants.dart';
import '../../ui/widgets/neon_slider.dart';
import '../../ui/widgets/info_panel.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';

class Law3Screen extends StatefulWidget {
  const Law3Screen({super.key});

  @override
  State<Law3Screen> createState() => _Law3ScreenState();
}

class _Law3ScreenState extends State<Law3Screen> with SingleTickerProviderStateMixin {
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

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
        title: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Text(l10n.law3ScreenTitle);
          },
        ),
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
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return InfoPanel(
                  title: selectedScene == Law3SceneType.collision ? l10n.collisions : l10n.rocketPropulsion,
                  description: selectedScene == Law3SceneType.collision ? l10n.newtonThirdLawDesc : l10n.rocketDescription,
                  formula: selectedScene == Law3SceneType.collision ? "F_AB = -F_BA" : "F_action = -F_reaction",
                );
              },
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
                  child: Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(l10n.demo),
                              const SizedBox(width: 8),
                              DropdownButton<Law3SceneType>(
                                value: selectedScene,
                                dropdownColor: AppColors.background,
                                underline: const SizedBox(),
                                items: [
                                  DropdownMenuItem(
                                    value: Law3SceneType.collision,
                                    child: Text(l10n.elasticCollisions),
                                  ),
                                  DropdownMenuItem(
                                    value: Law3SceneType.rocket,
                                    child: Text(l10n.rocketPropulsion),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => selectedScene = value);
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
                                    label: '${l10n.massA}: ${massA.toStringAsFixed(0)} kg',
                                    value: massA,
                                    min: 1,
                                    max: 50,
                                    onChanged: (val) {
                                      setState(() => massA = val);
                                      game.updateParameters(massA, massB, bounciness);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: NeonSlider(
                                    label: '${l10n.massB}: ${massB.toStringAsFixed(0)} kg',
                                    value: massB,
                                    min: 1,
                                    max: 50,
                                    onChanged: (val) {
                                      setState(() => massB = val);
                                      game.updateParameters(massA, massB, bounciness);
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
                                    label: '${l10n.bounciness}: ${bounciness.toStringAsFixed(2)}',
                                    value: bounciness,
                                    min: 0,
                                    max: 1,
                                    onChanged: (val) {
                                      setState(() => bounciness = val);
                                      game.updateParameters(massA, massB, bounciness);
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
                                  side: const BorderSide(color: AppColors.textSecondary),
                                ),
                                onPressed: () => game.resetSimulation(),
                                child: Text(l10n.reset, style: const TextStyle(color: AppColors.textPrimary)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAccent.withOpacity(0.2),
                                  side: const BorderSide(color: AppColors.primaryAccent),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                ),
                                onPressed: () => game.launch(),
                                child: Text(
                                  selectedScene == Law3SceneType.collision ? l10n.simulate : l10n.launch,
                                  style: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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