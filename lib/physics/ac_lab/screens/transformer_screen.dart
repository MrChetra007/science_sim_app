import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../providers/ac_provider.dart';
import '../flame/ac_game.dart';
import '../widgets/info_chip_row.dart';
import 'explanation_screen.dart';
import '../widgets/rewarded_timer_chip.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../l10n/generated/app_localizations.dart';

class TransformerScreen extends StatefulWidget {
  const TransformerScreen({super.key});

  @override
  State<TransformerScreen> createState() => _TransformerScreenState();
}

class _TransformerScreenState extends State<TransformerScreen> {
  late ACGame _transGame;

  @override
  void initState() {
    super.initState();
    _transGame = ACGame(provider: context.read<ACProvider>());
    _transGame.showOnlyTransformer = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ACProvider>();

    final isLocked = !provider.isTransformerLabUnlocked;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transformerLab),
        backgroundColor: const Color(0xFF0D1117),
        actions: [
          const RewardedTimerChip(),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleExplanationScreen(
                  title: l10n.transformerGuide,
                  accentColor: Colors.blueAccent,
                  whatIsIt: l10n.transformerDesc,
                  howItWorks: [
                    l10n.primaryCoilDesc,
                    l10n.secondaryCoilDesc,
                    l10n.turnsRatioDesc,
                    l10n.simulationDesc,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(flex: 5, child: GameWidget(game: _transGame)),
              const InfoChipRow(),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStats(provider, l10n),
                      const Divider(color: Colors.white10),
                      _buildSlider(
                        'Primary turns (Np)',
                        provider.primaryTurns.toDouble(),
                        10,
                        500,
                        (v) => provider.setPrimaryTurns(v.toInt()),
                      ),
                      _buildSlider(
                        'Secondary turns (Ns)',
                        provider.secondaryTurns.toDouble(),
                        10,
                        1000,
                        (v) => provider.setSecondaryTurns(v.toInt()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isLocked)
            _buildLockedOverlay(context, provider, l10n),
        ],
      ),
    );
  }

  Widget _buildLockedOverlay(
    BuildContext context,
    ACProvider provider,
    AppLocalizations l10n,
  ) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, color: Colors.amber, size: 80),
          const SizedBox(height: 20),
          Text(
            l10n.transformerLab,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.scientificProTier,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => showGlobalPlanDialog(context),
            icon: const Icon(Icons.star_rounded),
            label: Text(l10n.upgradeToUnlock),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ElevatedButton.icon(
          //   onPressed: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Loading Ad...')),
          //     );
          //     provider.activateRewardedUnlock();
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Lab Unlocked for 10 minutes!')),
          //     );
          //   },
          //   icon: const Icon(Icons.play_circle_fill),
          //   label: const Text('WATCH AD TO UNLOCK (10 MINS)'),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.amber,
          //     foregroundColor: Colors.black,
          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //   ),
          // ),
          // const SizedBox(height: 15),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.backToMenu,
              style: const TextStyle(color: Colors.cyan),
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildStats(ACProvider p, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statColumn(
          l10n.primaryVp,
          '${p.state.vp.toStringAsFixed(0)}V',
          Colors.amber,
        ),
        const Icon(Icons.arrow_forward, color: Colors.white24),
        _statColumn(
          l10n.ratio,
          '${p.turnsRatio.toStringAsFixed(2)}x',
          Colors.white70,
        ),
        const Icon(Icons.arrow_forward, color: Colors.white24),
        _statColumn(
          l10n.secondaryVp,
          '${p.secondaryVp.toStringAsFixed(0)}V',
          Colors.cyan,
        ),
      ],
    );
  }

  Widget _statColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double val,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${val.toInt()}',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
