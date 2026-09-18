import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;

import '../../../core/services/subscription_service.dart';
import '../../../core/widgets/ad_widgets.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/optics_mode.dart';
import '../theme.dart';
import 'simulation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPro = p.Provider.of<SubscriptionService>(context).isPro;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.opticAppBarName,
                    style: const TextStyle(
                        color: AppColors.text, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: l10n.opticAppBarSuffix,
                    style: TextStyle(
                        color: AppColors.accent, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 20, letterSpacing: -0.5),
            ),
            const Spacer(),
            IconButton(
              tooltip: l10n.opticLabSubtitle,
              icon: Icon(
                Icons.stars,
                color: isPro ? Colors.amber : AppColors.dim,
              ),
              onPressed: () => showGlobalPlanDialog(context),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.opticChooseLab,
                  style: const TextStyle(
                    color: AppColors.dim,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: OpticsMode.values.length,
                  itemBuilder: (context, i) => _ModeCard(
                      mode: OpticsMode.values[i],
                      l10n: l10n,
                      isPro: isPro),
                ),
              ),
              const SafeArea(child: GlobalBannerAdWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard(
      {required this.mode, required this.l10n, required this.isPro});

  final OpticsMode mode;
  final AppLocalizations l10n;
  final bool isPro;

  bool get _locked => mode.isPro && !isPro;

  void _handleTap(BuildContext context) {
    if (_locked) {
      showGlobalPlanDialog(context);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SimulationScreen(mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child:
                        Text(mode.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                  const Spacer(),
                  if (_locked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock, size: 12, color: Colors.black),
                          SizedBox(width: 3),
                          Text('PRO',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                mode.title(l10n),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _locked ? l10n.proUnlockMessage : mode.subtitle(l10n),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.dim,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _locked ? l10n.pProFeature : l10n.opticOpenMode,
                    style: const TextStyle(color: AppColors.accent, fontSize: 12),
                  ),
                  Icon(_locked ? Icons.lock_outline : Icons.arrow_forward,
                      size: 14, color: AppColors.accent),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}