import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import '../../core/theme/app_colors.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../bohr_model/bohr_screen.dart';
import '../electron_config/config_screen.dart';
import '../molecule_viewer/molecule_screen.dart';
import '../vsepr/vsepr_screen.dart';
import '../orbital_viewer/orbital_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);
    
    final modules = [
      _Module(
        icon: '⚛',
        title: sub.isPro ? 'Bohr Model' : 'Bohr Model ⭐',
        subtitle: sub.isPro ? 'Animate electrons orbiting' : 'PRO - Unlock for unlimited access',
        route: '/bohr',
        color: AppColors.orbitalS,
        isLocked: !sub.isPro,
      ),
      _Module(
        icon: '⚡',
        title: 'Electron Config',
        subtitle: 'Fill orbitals step by step',
        route: '/config',
        color: AppColors.orbitalP,
        isLocked: false,
      ),
      _Module(
        icon: '🔬',
        title: '3D Molecules',
        subtitle: 'Rotate ball-and-stick models',
        route: '/molecule',
        color: AppColors.orbitalD,
        isLocked: false,
      ),
      _Module(
        icon: '📐',
        title: 'VSEPR Shapes',
        subtitle: 'Geometry from electron pairs',
        route: '/vsepr',
        color: AppColors.catHalogen,
        isLocked: false,
      ),
      _Module(
        icon: '🌀',
        title: 'Orbital Viewer',
        subtitle: 'Explore s, p, d probability regions',
        route: '/orbital',
        color: AppColors.catNobleGas,
        isLocked: false,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   const Text('⚛', style: TextStyle(fontSize: 32)),
                   const SizedBox(width: 12),
                   Flexible(
                     child: Text('Atomic Lab', style: Theme.of(context).textTheme.displayLarge, overflow: TextOverflow.ellipsis),
                   ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: 44.0),
                child: Text('Interactive Chemistry Simulations',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    )),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: modules.length,
                  itemBuilder: (context, index) => _ModuleCard(module: modules[index]),
                ),
              ),
              const GlobalBannerAdWidget(),
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Built for Chemistry Students', style: TextStyle(fontSize: 10, color: AppColors.textHint, letterSpacing: 1.0))))
            ],
          ),
        ),
      ),
    );
  }
}

class _Module {
  final String icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;
  final bool isLocked;

  _Module({required this.icon, required this.title, required this.subtitle, required this.route, required this.color, required this.isLocked});
}

class _ModuleCard extends StatelessWidget {
  final _Module module;
  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (module.isLocked) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Premium Feature'),
              content: const Text('Upgrade to Premium to unlock Bohr Model and remove ads!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Maybe Later'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showGlobalPlanDialog(context);
                  },
                  child: const Text('Upgrade'),
                ),
              ],
            ),
          );
          return;
        }
        
        final screen = switch (module.route) {
          '/bohr' => const BohrScreen(),
          '/config' => const ConfigScreen(),
          '/molecule' => const MoleculeScreen(),
          '/vsepr' => const VseprScreen(),
          '/orbital' => const OrbitalScreen(),
          _ => null,
        };
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderDefault, width: 1.0),
              boxShadow: [
                  BoxShadow(
                      color: module.color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                  )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                     padding: const EdgeInsets.all(10),
                     decoration: BoxDecoration(
                         color: module.color.withOpacity(0.12),
                         shape: BoxShape.circle,
                     ),
                     child: Text(module.icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 16),
                  Text(module.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(module.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
                ],
              ),
            ),
          ),
          if (module.isLocked)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lock, size: 14, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
