import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/ph_colors.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import 'flame/titration_game.dart';
import 'providers/titration_provider.dart';
import 'widgets/ph_curve_chart.dart';

class TitrationScreen extends ConsumerStatefulWidget {
  const TitrationScreen({super.key});

  @override
  ConsumerState<TitrationScreen> createState() => _TitrationScreenState();
}

class _TitrationScreenState extends ConsumerState<TitrationScreen> {
  late final TitrationGame _game;
  Timer? _dropTimer;

  @override
  void initState() {
    super.initState();
    _game = TitrationGame(
      onDropLanded: (vol) {
        ref.read(titrationProvider.notifier).addAcidDrop(vol);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sub = p.Provider.of<SubscriptionService>(context, listen: false);
      if (sub.showInterstitialAds) {
        globalAdService.showInterstitialAd();
      }
    });
  }

  @override
  void dispose() {
    _dropTimer?.cancel();
    super.dispose();
  }

  void _startTitration() {
    ref.read(titrationProvider.notifier).toggleRunning();
    _dropTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted || !ref.read(titrationProvider).isRunning) {
        timer.cancel();
        return;
      }
      _game.spawnDrop();
    });
  }

  void _stopTitration() {
    ref.read(titrationProvider.notifier).toggleRunning();
    _dropTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(titrationProvider);

    // Sync game color with pH
    _game.updatePH(state.currentPH);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Titration Lab'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Simulation View
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.borderDefault, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Stack(
                    children: [
                      GameWidget(game: _game),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: _StatChip(
                          label: 'pH',
                          value: state.currentPH.toStringAsFixed(2),
                          color: PHColors.forPH(state.currentPH),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        right: 20,
                        child: _StatChip(
                          label: 'Acid Added',
                          value: '${state.acidAddedMl.toStringAsFixed(1)} mL',
                          color: AppColors.accentBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: state.isRunning ? _stopTitration : _startTitration,
                    icon: Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(state.isRunning ? 'Stop' : 'Start Drip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isRunning ? Colors.redAccent.withOpacity(0.2) : AppColors.accentGreen.withOpacity(0.2),
                      foregroundColor: state.isRunning ? Colors.redAccent : AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  TextButton.icon(
                    onPressed: () {
                      _stopTitration();
                      ref.read(titrationProvider.notifier).reset();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Lab'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Titration Curve Chart
              Text(
                'Titration Curve',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              PHCurveChart(spots: state.titrationCurve),
              const SizedBox(height: AppSpacing.lg),
              const GlobalBannerAdWidget(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
