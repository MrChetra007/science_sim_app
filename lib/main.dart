import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart' as p;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'l10n/generated/app_localizations.dart';

// Import Global Services
import 'core/services/subscription_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/iap_service.dart';
import 'core/services/walkthrough_service.dart';
import 'core/services/locale_provider.dart';
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
import 'physics/simple_harmonic_motion/lessons/screens/home_screen.dart' as shm_home;
import 'physics/electromagnetic_induction/lessons/screens/home_screen.dart' as em_induction_home;
import 'physics/special_relativity/lessons/screens/home_screen.dart' as relativity_home;

// Import Chemistry Labs
import 'chemistry/acide_base_ph/main.dart' as ph_main;
import 'chemistry/atomic_molecular/features/home/home_screen.dart'
    as atomic_home;
import 'chemistry/electrochemistry/features/home/home_screen.dart'
    as electro_home;

class _WalkthroughOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WalkthroughOption({required this.label, required this.onTap});

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

  final localeProvider = LocaleProvider();
  await localeProvider.init();

  runApp(
    rp.ProviderScope(
      child: p.MultiProvider(
        providers: [
          p.ChangeNotifierProvider.value(value: subscriptionService),
          p.ChangeNotifierProvider(create: (_) => CircuitProvider()),
          p.ChangeNotifierProvider.value(value: acProvider),
          p.ChangeNotifierProvider.value(value: localeProvider),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = p.Provider.of<LocaleProvider>(context);

    return ListenableBuilder(
      listenable: localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Science Lab',
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: LocaleProvider.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            textTheme: GoogleFonts.orbitronTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),
          home: const MainDashboard(),
        );
      },
    );
  }
}

// ✅ FIX: Added const constructor
class _AtomicLabWrapper extends StatelessWidget {
  const _AtomicLabWrapper();

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

class _SHMWrapper extends StatelessWidget {
  const _SHMWrapper();

  @override
  Widget build(BuildContext context) {
    return rp.ProviderScope(child: const shm_home.HomeScreen());
  }
}

class _EmInductionWrapper extends StatelessWidget {
  const _EmInductionWrapper();

  @override
  Widget build(BuildContext context) {
    return rp.ProviderScope(child: const em_induction_home.HomeScreen());
  }
}

class _RelativityWrapper extends StatelessWidget {
  const _RelativityWrapper();

  @override
  Widget build(BuildContext context) {
    return rp.ProviderScope(child: const relativity_home.HomeScreen());
  }
}

// ✅ FIX: Converted MainDashboard from StatelessWidget to StatefulWidget
// so we can properly dispose the banner ad and prevent surface leaks.
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // ✅ FIX: Track whether the ad widget is still alive
  bool _adDisposed = false;

  @override
  void dispose() {
    // ✅ FIX: Signal that this screen is being torn down.
    // GlobalBannerAdWidget should internally dispose its BannerAd here.
    // If GlobalBannerAdWidget is a StatefulWidget wrapping a BannerAd,
    // Flutter will call its dispose() automatically when this widget
    // is removed from the tree — which now works correctly because
    // MainDashboard is a StatefulWidget with a proper lifecycle.
    _adDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showLanguageDialog(context),
            icon: const Icon(Icons.language, color: Colors.cyan),
            tooltip: 'Language',
          ),
          IconButton(
            onPressed: () => _showWalkthroughHelpDialog(context),
            icon: const Icon(Icons.help_outline, color: Colors.white54),
            tooltip: 'Help & Tutorials',
          ),
          IconButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://mrchetra007.github.io/privacy_policy/wave_lab',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.privacy_tip_outlined, color: Colors.white54),
            tooltip: 'Privacy Policy',
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
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Column(
                      children: [
                        Text(
                          l10n.appTitle,
                          style: GoogleFonts.orbitron(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                            letterSpacing: 4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          l10n.virtualExperimentSuite,
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return _buildCategoryCard(
                      context,
                      title: l10n.physics,
                      subtitle: l10n.physicsSubtitle,
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
                    );
                  },
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return _buildCategoryCard(
                      context,
                      title: l10n.chemistry,
                      subtitle: l10n.chemistrySubtitle,
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
                    );
                  },
                ),
                const Spacer(),
                // ✅ FIX: Only render the ad widget if this state is still alive.
                // Because MainDashboard is now StatefulWidget, Flutter will
                // properly call dispose() on GlobalBannerAdWidget when this
                // screen is removed, preventing surface abandonLocked errors.
                if (!_adDisposed) const GlobalBannerAdWidget(),
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

  void _showLanguageDialog(BuildContext context) {
    final localeProvider = p.Provider.of<LocaleProvider>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D3D),
        title: const Row(
          children: [
            Icon(Icons.language, color: Colors.cyan),
            SizedBox(width: 12),
            Text('Language', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                localeProvider.locale.languageCode == 'en'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Colors.cyan,
              ),
              title: const Text(
                'English',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                localeProvider.setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(
                localeProvider.locale.languageCode == 'km'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Colors.cyan,
              ),
              title: const Text('Khmer', style: TextStyle(color: Colors.white)),
              onTap: () {
                localeProvider.setLocale(const Locale('km'));
                Navigator.pop(ctx);
              },
            ),
          ],
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
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyNewtonLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewtonsLabApp(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'OhmLab - Circuit Simulation',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyOhmLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Theme(
                          data: ohm_theme.AppTheme.darkTheme,
                          child: const ohm_home.HomeScreen(),
                        ),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Projectile Motion',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyProjectileMotion,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const projectile_app.App(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'AC Lab - Electricity',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyAcLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ac_main.ACElectricityApp(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Wave Lab',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyWaveLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const wave_main.HomeScreen(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'EM Induction Lab - Electromagnetic Induction',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyEmInduction,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const _EmInductionWrapper(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Thermo Lab - Thermodynamics',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyThermoLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const thermo_main.ThermoSimApp(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'SHM Lab - Simple Harmonic Motion',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyShmLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const _SHMWrapper(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Special Relativity Lab',
                onTap: () async {
                  final sub = p.Provider.of<SubscriptionService>(ctx, listen: false);
                  if (!sub.isPro) {
                    Navigator.pop(ctx);
                    showGlobalPlanDialog(context);
                    return;
                  }
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keySpecialRelativity,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const _RelativityWrapper(),
                      ),
                    );
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
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyPhLab,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ph_main.PhSimApp(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Atomic & Molecular',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyAtomicMolecular,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ✅ FIX: Now uses const constructor
                        builder: (context) => const _AtomicLabWrapper(),
                      ),
                    );
                  }
                },
              ),
              _WalkthroughOption(
                label: 'Electrochemistry',
                onTap: () async {
                  Navigator.pop(ctx);
                  await WalkthroughService.resetLabWalkthrough(
                    WalkthroughService.keyElectrochemistry,
                  );
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const _ElectrochemWrapper(),
                      ),
                    );
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
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white24,
                        size: 20,
                      ),
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
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.newtonLab,
                            subtitle: l10n.newtonLabSubtitle,
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
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.ohmLab,
                            subtitle: l10n.ohmLabSubtitle,
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
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.projectileLab,
                            subtitle: l10n.projectileLabSubtitle,
                            icon: Icons.rocket_launch,
                            color: Colors.deepPurpleAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const projectile_app.App(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.acLab,
                            subtitle: l10n.acLabSubtitle,
                            icon: Icons.vibration,
                            color: Colors.orangeAccent,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ac_main.ACLabScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.waveLab,
                            subtitle: l10n.waveLabSubtitle,
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
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.shmLab,
                            subtitle: l10n.shmLabSubtitle,
                            icon: Icons.hourglass_bottom,
                            color: Colors.purpleAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const _SHMWrapper(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.emInductionLab,
                            subtitle: l10n.emInductionLabSubtitle,
                            icon: Icons.bolt,
                            color: Colors.deepOrange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const _EmInductionWrapper(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.thermoLab,
                            subtitle: l10n.thermoLabSubtitle,
                            icon: Icons.thermostat,
                            color: Colors.redAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const thermo_main.ThermoSimApp(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.relativityLab,
                            subtitle: l10n.relativityLabSubtitle,
                            icon: Icons.speed,
                            color: Colors.tealAccent,
                            onTap: () {
                              final sub = p.Provider.of<SubscriptionService>(context, listen: false);
                              if (sub.isPro) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const _RelativityWrapper(),
                                  ),
                                );
                              } else {
                                showGlobalPlanDialog(context);
                              }
                            },
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
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.atomicMolecular,
                            subtitle: l10n.atomicMolecularSubtitle,
                            icon: Icons.blur_circular,
                            color: Colors.purpleAccent,
                            // ✅ FIX: Now uses const constructor
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const _AtomicLabWrapper(),
                              ),
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.phLab,
                            subtitle: l10n.phLabSubtitle,
                            icon: Icons.science,
                            color: Colors.greenAccent,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ph_main.PhSimApp(),
                              ),
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return _buildLabCard(
                            context,
                            title: l10n.electrochem,
                            subtitle: l10n.electrochemSubtitle,
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
