import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart' as p;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

// Import Global Services
import 'core/services/subscription_service.dart';
import 'core/services/ad_service.dart';
import 'core/widgets/plan_picker.dart';

// Import Newton Lab
import 'newton_lab/app.dart';

// Import Ohm Lab
import 'ohm_lab/screens/home_screen.dart' as ohm_home;
import 'ohm_lab/providers/circuit_provider.dart';
import 'ohm_lab/core/theme.dart' as ohm_theme;

// Import Projectile Motion Lab
import 'projectile_motion/app.dart' as projectile_app;

// Import AC Lab
import 'ac_lab/main_standalone.dart' as ac_main;
import 'ac_lab/providers/ac_provider.dart';

// Import Wave Lab
import 'wave_lab/main_standalone.dart' as wave_main;

// Import Acid Base Lab
import 'chemistry/acide_base_ph/main.dart' as ph_main;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Global Services
  final subscriptionService = SubscriptionService();
  await subscriptionService.init();
  await globalAdService.init();

  // Initialize Lab Specific dependencies
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
      title: 'Physics Simulation Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => _showPlanDialog(context),
            icon: Icon(Icons.stars, color: sub.isPro ? Colors.amber : Colors.cyan),
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
                Text(
                  'PHYSICS LAB',
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
                const SizedBox(height: 30),
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
                            MaterialPageRoute(builder: (context) => const NewtonsLabApp()),
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
                            MaterialPageRoute(builder: (context) => const projectile_app.App()),
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
                              builder: (context) => const wave_main.HomeScreen(),
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

  void _showPlanDialog(BuildContext context) {
    showGlobalPlanDialog(context);
  }

  Widget _buildLabCard(BuildContext context, {
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
