import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedFormulaBox extends StatefulWidget {
  final String formula;
  final Color accentColor;

  const AnimatedFormulaBox({
    super.key,
    required this.formula,
    required this.accentColor,
  });

  @override
  State<AnimatedFormulaBox> createState() => _AnimatedFormulaBoxState();
}

class _AnimatedFormulaBoxState extends State<AnimatedFormulaBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgDeep.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.1),
                blurRadius: _glowAnimation.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.formula,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.accentColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }
}
