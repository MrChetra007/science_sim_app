import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import '../../../core/services/subscription_service.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/ad_widgets.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../l10n/generated/app_localizations.dart';
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
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return Column(
                          children: [
                            Text(
                              l10n.newtonLabTitle,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(color: AppColors.primaryAccent),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.newtonLabSubtitle,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return SceneCard(
                          walkthroughKey: _law1Key,
                          title: l10n.law1Title,
                          tagline: l10n.law1Tagline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Law1Screen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return SceneCard(
                          walkthroughKey: _law2Key,
                          title: l10n.law2Title,
                          tagline: l10n.law2Tagline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Law2Screen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return SceneCard(
                          walkthroughKey: _law3Key,
                          title: l10n.law3Title,
                          tagline: l10n.law3Tagline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Law3Screen(),
                              ),
                            );
                          },
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
