import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../providers/galvanic_state.dart';
import '../flame/cell_game.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CellCanvasWidget extends StatefulWidget {
  final GalvanicState state;

  const CellCanvasWidget({super.key, required this.state});

  @override
  State<CellCanvasWidget> createState() => _CellCanvasWidgetState();
}

class _CellCanvasWidgetState extends State<CellCanvasWidget> {
  late final CellGame _game;

  @override
  void initState() {
    super.initState();
    _game = CellGame(state: widget.state);
  }

  @override
  void didUpdateWidget(covariant CellCanvasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _game.updateState(widget.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            GameWidget(game: _game),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: widget.state.isSpontaneous 
                    ? AppColors.accentGreen.withValues(alpha: 0.1) 
                    : AppColors.accentRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  widget.state.isSpontaneous ? 'SPONTANEOUS' : 'NON-SPONTANEOUS',
                  style: TextStyle(
                    color: widget.state.isSpontaneous ? AppColors.accentGreen : AppColors.accentRed,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
