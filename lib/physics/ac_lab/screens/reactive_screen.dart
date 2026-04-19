import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../providers/ac_provider.dart';
import '../flame/ac_game.dart';
import '../widgets/info_chip_row.dart';
import '../widgets/rewarded_timer_chip.dart';
import 'explanation_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../l10n/generated/app_localizations.dart';

class ReactiveScreen extends StatefulWidget {
  const ReactiveScreen({super.key});

  @override
  State<ReactiveScreen> createState() => _ReactiveScreenState();
}

class _ReactiveScreenState extends State<ReactiveScreen> {
  late ACGame _rlcGame;

  @override
  void initState() {
    super.initState();
    _rlcGame = ACGame(provider: context.read<ACProvider>());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ACProvider>();
    final isLocked = !provider.isReactiveLabUnlocked;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rlcReactiveLab),
        backgroundColor: const Color(0xFF0D1117),
        actions: [
          const RewardedTimerChip(),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleExplanationScreen(
                  title: l10n.rlcGuide,
                  accentColor: Colors.purpleAccent,
                  whatIsIt: l10n.rlcDesc,
                  howItWorks: [
                    'Impedance (Z) is the total opposition to AC flow, combining resistance and reactance.',
                    'Inductors (L) cause the current to lag behind the voltage.',
                    'Capacitors (C) cause the current to lead the voltage.',
                    'Phase Angle (φ) shows the timing difference between voltage and current peaks.',
                    'Adjusting L and C allows you to see how the system reaches resonance.',
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
              Expanded(flex: 5, child: GameWidget(game: _rlcGame)),
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
                        'Resistance (R)',
                        provider.state.resistance,
                        1,
                        500,
                        provider.setResistance,
                        'Ω',
                      ),
                      _buildSlider(
                        'Inductance (L)',
                        provider.state.inductance,
                        0,
                        5,
                        provider.setInductance,
                        'H',
                      ),
                      _buildSlider(
                        'Capacitance (C)',
                        provider.state.capacitance * 1000,
                        0,
                        50,
                        (v) => provider.setCapacitance(v / 1000),
                        'mF',
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
          const Icon(Icons.lock_outline, color: Colors.purpleAccent, size: 80),
          const SizedBox(height: 20),
          Text(
            l10n.rlcLab,
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
              l10n.expertLabProTier,
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
          //     backgroundColor: Colors.purpleAccent,
          //     foregroundColor: Colors.white,
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
    final s = p.state;
    final phiDeg = s.phi * 180 / math.pi;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statColumn(
          l10n.impedanceZ,
          '${s.impedance.toStringAsFixed(1)}Ω',
          Colors.amber,
        ),
        _statColumn(
          l10n.phase,
          '${phiDeg.toStringAsFixed(1)}°',
          Colors.purpleAccent,
        ),
        _statColumn(
          l10n.avgPower,
          '${s.avgPower.toStringAsFixed(1)}W',
          Colors.redAccent,
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
            fontSize: 16,
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
    String unit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${val.toStringAsFixed(2)} $unit',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Slider(
          value: val.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
