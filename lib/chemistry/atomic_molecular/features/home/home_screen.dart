import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      _Module(
        icon: '⚛',
        title: 'Bohr Model',
        subtitle: 'Animate electrons orbiting',
        route: '/bohr',
        color: AppColors.orbitalS,
      ),
      _Module(
        icon: '⚡',
        title: 'Electron Config',
        subtitle: 'Fill orbitals step by step',
        route: '/config',
        color: AppColors.orbitalP,
      ),
      _Module(
        icon: '🔬',
        title: '3D Molecules',
        subtitle: 'Rotate ball-and-stick models',
        route: '/molecule',
        color: AppColors.orbitalD,
      ),
      _Module(
        icon: '📐',
        title: 'VSEPR Shapes',
        subtitle: 'Geometry from electron pairs',
        route: '/vsepr',
        color: AppColors.catHalogen,
      ),
      _Module(
        icon: '🌀',
        title: 'Orbital Viewer',
        subtitle: 'Explore s, p, d probability regions',
        route: '/orbital',
        color: AppColors.catNobleGas,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                   const Text('⚛', style: TextStyle(fontSize: 32)),
                   const SizedBox(width: 12),
                   Text('Atomic Lab', style: Theme.of(context).textTheme.displayLarge),
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
              // Footer / Branding
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

  _Module({required this.icon, required this.title, required this.subtitle, required this.route, required this.color});
}

class _ModuleCard extends StatelessWidget {
  final _Module module;
  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(module.route),
      child: Container(
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
    );
  }
}
