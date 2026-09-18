import 'package:flutter/material.dart';

import '../models/optics_mode.dart';
import '../theme.dart';
import 'simulation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Optics',
                    style: TextStyle(
                        color: AppColors.text, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: 'Lab',
                    style: TextStyle(
                        color: AppColors.accent, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 20, letterSpacing: -0.5),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Choose a lab',
                  style: TextStyle(
                    color: AppColors.dim,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: OpticsMode.values.length,
                  itemBuilder: (context, i) =>
                      _ModeCard(mode: OpticsMode.values[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode});

  final OpticsMode mode;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SimulationScreen(mode: mode),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(mode.emoji, style: const TextStyle(fontSize: 22)),
              ),
              const Spacer(),
              Text(
                mode.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                mode.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.dim,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Open',
                    style: TextStyle(color: AppColors.accent, fontSize: 12),
                  ),
                  Icon(Icons.arrow_forward,
                      size: 14, color: AppColors.accent),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}