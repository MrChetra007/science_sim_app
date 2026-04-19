import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'law1_game.dart';
import '../../core/constants.dart';
import '../../physics/friction_model.dart';
import '../../ui/widgets/neon_slider.dart';
import '../../ui/widgets/info_panel.dart';
import '../../../../core/widgets/ad_widgets.dart';

class Law1Screen extends StatefulWidget {
  const Law1Screen({super.key});

  @override
  State<Law1Screen> createState() => _Law1ScreenState();
}

class _Law1ScreenState extends State<Law1Screen>
    with SingleTickerProviderStateMixin {
  late Law1Game game;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  SurfaceType selectedSurface = SurfaceType.ice;
  double initialSpeed = 10.0;
  bool isGravityOn = true;

  @override
  void initState() {
    super.initState();
    game = Law1Game();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1), // Slide from bottom
          end: Offset.zero,
        ).animate(
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
        title: const Text('Law 1: Inertia & Friction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Dark background grid
          Container(color: AppColors.background),
          CustomPaint(painter: GridPainter(), child: Container()),

          // Flame Game
          SafeArea(child: GameWidget(game: game)),

          // Info Panel overlay
          const Positioned(
            top: 100,
            right: 20,
            width: 300,
            child: InfoPanel(
              title: "Newton's First Law",
              description:
                  "An object remains at rest or in uniform motion unless acted upon by a net force.",
              formula: "ΣF = 0 → a = 0",
            ),
          ),

          // Control Panel overlay
          Positioned(
            bottom: 80,
            left: 17,
            right: 17,
            child: SlideTransition(
              position: _slideAnimation,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.surface.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Surface Row
                      Row(
                        children: [
                          const Text('🧊', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          const Text('Surface'),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryAccent.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<SurfaceType>(
                                value: selectedSurface,
                                dropdownColor: AppColors.background,
                                isDense: true,
                                style: const TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontSize: 13,
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.primaryAccent,
                                ),
                                items: SurfaceType.values.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(FrictionModel.getName(type)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => selectedSurface = value);
                                    game.updateSurface(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Gravity Row
                      Row(
                        children: [
                          const Text('🌍', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          const Text('Gravity'),
                          const Spacer(),
                          Switch(
                            value: isGravityOn,
                            activeThumbColor: AppColors.primaryAccent,
                            onChanged: (val) =>
                                setState(() => isGravityOn = val),
                          ),
                        ],
                      ),

                      Divider(
                        color: AppColors.primaryAccent.withOpacity(0.2),
                        height: 24,
                      ),

                      // Speed + Launch Row
                      Row(
                        children: [
                          const Text('Speed', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: NeonSlider(
                              label: '',
                              value: initialSpeed,
                              min: 1,
                              max: 20,
                              onChanged: (val) =>
                                  setState(() => initialSpeed = val),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 52,
                            child: Text(
                              '${initialSpeed.toStringAsFixed(1)}\nm/s',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Launch Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryAccent
                                    .withOpacity(0.15),
                                side: const BorderSide(
                                  color: AppColors.primaryAccent,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadowColor: AppColors.primaryAccent,
                                elevation: 8,
                              ).copyWith(
                                overlayColor: WidgetStateProperty.all(
                                  AppColors.primaryAccent.withOpacity(0.1),
                                ),
                              ),
                          onPressed: () {
                            game.launchPuck(
                              initialSpeed,
                              selectedSurface,
                              isGravityOn,
                            );
                          },
                          child: const Text(
                            'LAUNCH',
                            style: TextStyle(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
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
