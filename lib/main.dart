import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart' as p;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

// Import Global Services
import 'core/services/subscription_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/iap_service.dart';
import 'core/services/walkthrough_service.dart';
import 'core/widgets/plan_picker.dart';
import 'core/widgets/ad_widgets.dart';
import 'core/widgets/feedback_dialog.dart';

// Import Physics Labs
import 'physics/newton_lab/app.dart';
import 'physics/ohm_lab/screens/home_screen.dart' as ohm_home;
import 'physics/ohm_lab/providers/circuit_provider.dart';
import 'physics/ohm_lab/core/theme.dart' as ohm_theme;
import 'physics/thermo_lab/main.dart' as thermo_main;
import 'physics/projectile_motion/app.dart' as projectile_app;
import 'physics/ac_lab/main_standalone.dart' as ac_main;
import 'physics/ac_lab/providers/ac_provider.dart';
import 'physics/wave_lab/main_standalone.dart' as wave_main;

// Import Chemistry Labs
import 'chemistry/acide_base_ph/main.dart' as ph_main;
import 'chemistry/atomic_molecular/features/home/home_screen.dart'
    as atomic_home;
import 'chemistry/electrochemistry/features/home/home_screen.dart'
    as electro_home;

class _WalkthroughOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WalkthroughOption({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.cyan, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final subscriptionService = SubscriptionService();
  await subscriptionService.init();
  await globalAdService.init();
  await IAPService().init();
  
  await IAPService().verifySubscriptionStatus();

  final acProvider = ACProvider();
  await acProvider.loadPrefs();

  try {
    await SoLoud.instance.init();
  } catch (e) {
    debugPrint('SoLoud initialization failed: $e');
  }

  runApp(
    rp.ProviderScope(
      child: p.MultiProvider(
        providers: [
          p.ChangeNotifierProvider.value(value: subscriptionService),
          p.ChangeNotifierProvider(create: (_) => CircuitProvider()),
          p.ChangeNotifierProvider.value(value: acProvider),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Science Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainDashboard(),
    );
  }
}

class _AtomicLabWrapper extends StatelessWidget {
  // ignore: prefer_const_constructors
  @override
  Widget build(BuildContext context) {
    return rp.ProviderScope(child: atomic_home.HomeScreen());
  }
}

class _ElectrochemWrapper extends StatelessWidget {
  const _ElectrochemWrapper();

  @override
  Widget build(BuildContext context) {
    return rp.ProviderScope(child: electro_home.HomeScreen());
  }
}

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showWalkthroughHelpDialog(context),
            icon: const Icon(Icons.help_outline, color: Colors.white54),
            tooltip: 'Help & Tutorials',
          ),
          TextButton.icon(
            onPressed: () => showGlobalPlanDialog(context),
            icon: Icon(
              Icons.stars,
              color: sub.isPro ? Colors.amber : Colors.cyan,
            ),
            label: Text(sub.currentPlan.name.toUpperCase()),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey.shade900, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Text(
                  'SCIENCE LAB',
                  style: GoogleFonts.orbitron(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    letterSpacing: 4,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Virtual Experiment Suite',
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                _buildCategoryCard(
                  context,
                  title: "PHYSICS",
                  subtitle: "Mechanics, Waves & Electricity",
                  icon: Icons.speed,
                  color: Colors.cyanAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhysicsDashboard(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildCategoryCard(
                  context,
                  title: "CHEMISTRY",
                  subtitle: "Acids, Bases & Reactions",
                  icon: Icons.science,
                  color: Colors.greenAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChemistryDashboard(),
                      ),
                    );
                  },
                ),
                const Spacer(),
                const GlobalBannerAdWidget(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showWalkthroughHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D3D),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.cyan),
            SizedBox(width: 12),
            Text('Help & Tutorials', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Replay walkthrough tutorials for any lab:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              const Text(
                'PHYSICS LABS',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              _WalkthroughOption(
                label: 'NewtonLab - Laws of Motion',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyNewtonLab);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewtonsLabApp()));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'OhmLab - Circuit Simulation',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyOhmLab);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Theme(data: ohm_theme.AppTheme.darkTheme, child: const ohm_home.HomeScreen())));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Projectile Motion',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyProjectileMotion);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const projectile_app.App()));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'AC Lab - Electricity',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyAcLab);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ac_main.ACElectricityApp()));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Wave Lab',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyWaveLab);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const wave_main.HomeScreen()));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Thermo Lab - Thermodynamics',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyThermoLab);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const thermo_main.ThermoSimApp()));
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'CHEMISTRY LABS',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              _WalkthroughOption(
                label: 'pH Lab',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyPhLab);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ph_main.PhSimApp()));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Atomic & Molecular',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyAtomicMolecular);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => _AtomicLabWrapper()));
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Electrochemistry',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(WalkthroughService.keyElectrochemistry);
                  if (ctx.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => _ElectrochemWrapper()));
                  }
                },
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  FeedbackDialog.show(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.feedback, color: Colors.orange, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Send Feedback',
                          style: TextStyle(color: Colors.orange, fontSize: 14),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white24, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}

class PhysicsDashboard extends StatelessWidget {
  const PhysicsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PHYSICS',
          style: GoogleFonts.orbitron(color: Colors.cyanAccent),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => showGlobalPlanDialog(context),
            icon: Icon(
              Icons.stars,
              color: sub.isPro ? Colors.amber : Colors.cyan,
            ),
            label: Text(sub.currentPlan.name.toUpperCase()),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey.shade900, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      _buildLabCard(
                        context,
                        title: "NEWTON",
                        subtitle: "Laws of Motion",
                        icon: Icons.architecture,
                        color: Colors.cyanAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewtonsLabApp(),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "OHM",
                        subtitle: "Electricity",
                        icon: Icons.bolt,
                        color: Colors.amberAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Theme(
                                data: ohm_theme.AppTheme.darkTheme,
                                child: const ohm_home.HomeScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "PROJECTILE",
                        subtitle: "Kinematics",
                        icon: Icons.rocket_launch,
                        color: Colors.deepPurpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const projectile_app.App(),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "AC LAB",
                        subtitle: "Alternating Current",
                        icon: Icons.vibration,
                        color: Colors.orangeAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ac_main.ACLabScreen(),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "WAVE LAB",
                        subtitle: "Wave Mechanics",
                        icon: Icons.waves,
                        color: Colors.lightBlueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const wave_main.HomeScreen(),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "THERMO",
                        subtitle: "Thermodynamics",
                        icon: Icons.thermostat,
                        color: Colors.redAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const thermo_main.ThermoSimApp(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Select a module to begin simulation',
                    style: TextStyle(color: Colors.white30, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25), width: 1),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChemistryDashboard extends StatelessWidget {
  const ChemistryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CHEMISTRY',
          style: GoogleFonts.orbitron(color: Colors.greenAccent),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => showGlobalPlanDialog(context),
            icon: Icon(
              Icons.stars,
              color: sub.isPro ? Colors.amber : Colors.cyan,
            ),
            label: Text(sub.currentPlan.name.toUpperCase()),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade900.withOpacity(0.3),
              Colors.blueGrey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      _buildLabCard(
                        context,
                        title: "ATOMIC & MOLECULAR",
                        subtitle: "Atoms & Molecules",
                        icon: Icons.blur_circular,
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _AtomicLabWrapper(),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "pH LAB",
                        subtitle: "Acids & Bases",
                        icon: Icons.science,
                        color: Colors.greenAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ph_main.PhSimApp(),
                            ),
                          );
                        },
                      ),
                      _buildLabCard(
                        context,
                        title: "ELECTROCHEM",
                        subtitle: "Batteries & Electrolysis",
                        icon: Icons.bolt,
                        color: Colors.orangeAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _ElectrochemWrapper(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Select a module to begin simulation',
                    style: TextStyle(color: Colors.white30, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25), width: 1),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
