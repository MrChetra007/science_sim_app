import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class WarningBanner extends StatefulWidget {
  final bool isDangerous;

  const WarningBanner({super.key, required this.isDangerous});

  @override
  State<WarningBanner> createState() => _WarningBannerState();
}

class _WarningBannerState extends State<WarningBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: widget.isDangerous
          ? FadeTransition(
              opacity: _controller.drive(CurveTween(curve: Curves.easeInOut)),
              child: Container(
                key: const ValueKey('warning'),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0508),
                  border: Border.all(color: const Color(0xFFFF4455)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF4455), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.ohmsLawWarning,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFFF4455),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}
