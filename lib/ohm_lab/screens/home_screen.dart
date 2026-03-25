import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import '../providers/circuit_provider.dart';
import '../flame/circuit_game.dart';
import '../widgets/slider_control.dart';
import '../widgets/readout_panel.dart';
import '../widgets/power_bar.dart';
import '../widgets/warning_banner.dart';
import '../core/theme.dart';
import 'learn_screen.dart';
import '../../core/widgets/ad_widgets.dart';
import '../../core/widgets/plan_picker.dart';
import '../../core/services/subscription_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CircuitGame _circuitGame;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _circuitGame = CircuitGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GlobalBannerAdWidget(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [_buildSimulator(context), const LearnScreen()],
            ),
          ),
          const GlobalBannerAdWidget(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: AppTheme.background,
          selectedItemColor: AppTheme.blue,
          unselectedItemColor: Colors.white24,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 10,
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'SIMULATOR'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'LEARN'),
          ],
        ),
      ),
    );
  }

  bool _wasDangerous = false;

  Widget _buildSimulator(BuildContext context) {
    return Consumer<CircuitProvider>(
      builder: (context, provider, child) {
        // Update game values
        _circuitGame.updateValues(provider.voltage, provider.resistance);

        // Haptic Feedback on danger threshold
        if (provider.isDangerous && !_wasDangerous) {
          HapticFeedback.heavyImpact();
        }
        _wasDangerous = provider.isDangerous;

        return SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Column(
                  children: [
                    _buildHeader(context),
                    Expanded(flex: 3, child: _buildGameContainer()),
                    WarningBanner(isDangerous: provider.isDangerous),
                    Expanded(flex: 4, child: _buildControls(provider)),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _buildHeader(context),
                          Expanded(child: _buildGameContainer()),
                          WarningBanner(isDangerous: provider.isDangerous),
                        ],
                      ),
                    ),
                    Expanded(flex: 4, child: _buildControls(provider)),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final sub = Provider.of<SubscriptionService>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "OHM'S LAW",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.blue,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.stars, color: sub.isPro ? Colors.amber : Colors.white24),
            onPressed: () => showGlobalPlanDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: GameWidget(
        game: _circuitGame,
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildControls(CircuitProvider provider) {
    final isCompact = MediaQuery.of(context).size.width < 350;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ReadoutPanel(
            voltage: provider.voltage,
            resistance: provider.resistance,
            current: provider.current,
          ),
          const SizedBox(height: 24),
          SliderControl(
            label: "VOLTAGE",
            unit: "V",
            min: 1.0,
            max: 120.0,
            color: AppTheme.amber,
            value: provider.voltage,
            onChanged: (v) => provider.setVoltage(v),
          ),
          const SizedBox(height: 16),
          SliderControl(
            label: "RESISTANCE",
            unit: "Ω",
            min: 1.0,
            max: 1000.0,
            color: AppTheme.green,
            value: provider.resistance,
            onChanged: (r) => provider.setResistance(r),
          ),
          const SizedBox(height: 24),
          PowerBar(power: provider.power),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
