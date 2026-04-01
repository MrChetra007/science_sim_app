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
    final provider = context.watch<ACProvider>();

    final isLocked = !provider.isTransformerLabUnlocked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRANSFORMER LAB'),
        backgroundColor: const Color(0xFF0D1117),
        actions: [
          const RewardedTimerChip(),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ModuleExplanationScreen(
                  title: 'Transformer Guide',
                  accentColor: Colors.blueAccent,
                  whatIsIt:
                      'A transformer uses electromagnetic induction to transfer electrical energy between two or more circuits. It can increase (step-up) or decrease (step-down) voltage levels.',
                  howItWorks: [
                    'The Primary turns (Np) determine the number of wire loops on the input side.',
                    'The Secondary turns (Ns) determine the loops on the output side.',
                    'Turns Ratio (Ns/Np) defines the voltage transformation. If Ns > Np, it steps up voltage.',
                    'The simulation shows the real-time conversion from Primary Vp to Secondary Vp based on your settings.',
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
                      _buildStats(provider),
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
            _buildLockedOverlay(context, provider, 'Transformer Lab'),
        ],
      ),
    );
  }

  Widget _buildLockedOverlay(
    BuildContext context,
    ACProvider provider,
    String title,
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
            '$title Locked',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'This lab is available in the Scientific Pro tier. You can also unlock it temporarily by watching a short ad.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => showGlobalPlanDialog(context),
            icon: const Icon(Icons.star_rounded),
            label: const Text('UPGRADE TO UNLOCK PERMANENTLY'),
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
            child: const Text(
              'BACK TO MENU',
              style: TextStyle(color: Colors.cyan),
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildStats(ACProvider p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statColumn(
          'Primary Vp',
          '${p.state.vp.toStringAsFixed(0)}V',
          Colors.amber,
        ),
        Icon(Icons.arrow_forward, color: Colors.white24),
        _statColumn(
          'Ratio',
          '${p.turnsRatio.toStringAsFixed(2)}x',
          Colors.white70,
        ),
        Icon(Icons.arrow_forward, color: Colors.white24),
        _statColumn(
          'Secondary Vp',
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
