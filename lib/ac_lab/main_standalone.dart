import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:flame/game.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'providers/ac_provider.dart';
import 'flame/ac_game.dart';
import 'widgets/control_panel.dart';
import 'widgets/info_chip_row.dart';
import 'widgets/fact_cards.dart';
import 'screens/oscilloscope_screen.dart';
import 'screens/transformer_screen.dart';
import 'screens/reactive_screen.dart';
import '../../core/widgets/plan_picker.dart';
import 'widgets/rewarded_timer_chip.dart';
import '../core/widgets/ad_widgets.dart';
import '../core/services/subscription_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final acProvider = ACProvider();
  await acProvider.loadPrefs();

  runApp(
    p.ChangeNotifierProvider.value(
      value: acProvider,
      child: const ACElectricityApp(),
    ),
  );
}

class ACElectricityApp extends StatelessWidget {
  const ACElectricityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AC Electricity Lab',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07090D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.cyan,
        ),
      ),
      home: const ACLabScreen(),
    );
  }
}

class ACLabScreen extends StatefulWidget {
  const ACLabScreen({super.key});

  @override
  State<ACLabScreen> createState() => _ACLabScreenState();
}

class _ACLabScreenState extends State<ACLabScreen> {
  late ACGame _acGame;

  @override
  void initState() {
    super.initState();
    _acGame = ACGame(provider: context.read<ACProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AC ELECTRICITY LAB', 
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0D1117),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: 'Oscilloscope Mode',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OscilloscopeScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync_alt),
            tooltip: 'Transformer Lab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransformerScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bolt),
            tooltip: 'RLC Reactive Lab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReactiveScreen()),
              );
            },
          ),
          const RewardedTimerChip(),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LearnScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.workspace_premium, color: p.Provider.of<SubscriptionService>(context).isPro ? Colors.amber : Colors.white24),
            tooltip: 'Upgrade Lab',
            onPressed: () => showGlobalPlanDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: GameWidget(game: _acGame)
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
            const InfoChipRow().animate().fadeIn(delay: 400.ms),
            Expanded(
              flex: 4, // Adjusted to make room for banner
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const ControlPanel(),
                    const SizedBox(height: 12),
                    const FactCards(),
                  ],
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.05, end: 0),
              ),
            ),
            const GlobalBannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AC THEORY')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('What is AC?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
          SizedBox(height: 8),
          Text('Alternating Current (AC) is a type of electrical current in which the direction of the flow of electrons switches back and forth at regular intervals or cycles.', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16),
          Text('Key Concepts:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyan)),
          SizedBox(height: 8),
          BulletItem(text: 'Vp (Peak Voltage): The maximum voltage reached in a cycle.'),
          BulletItem(text: 'Frequency (Hz): How many cycles occur per second.'),
          BulletItem(text: 'Vrms: The effective voltage (heating power) equivalent to DC.'),
          BulletItem(text: 'Phasor: A rotating vector that visualizes the sine wave phase.'),
        ],
      ),
    );
  }
}

class BulletItem extends StatelessWidget {
  final String text;
  const BulletItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }
}
