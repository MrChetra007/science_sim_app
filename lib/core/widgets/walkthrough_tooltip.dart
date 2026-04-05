import 'dart:ui';
import 'package:flutter/material.dart';

class WalkthroughTooltip extends StatelessWidget {
  final String title;
  final String description;
  final String? tipText;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final bool isLastStep;
  final Alignment tooltipAlignment;
  final Offset? targetPosition;
  final Size? targetSize;

  const WalkthroughTooltip({
    super.key,
    required this.title,
    required this.description,
    this.tipText,
    this.onNext,
    this.onSkip,
    this.isLastStep = false,
    this.tooltipAlignment = Alignment.topRight,
    this.targetPosition,
    this.targetSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (targetPosition != null && targetSize != null)
          _SpotlightOverlay(
            targetPosition: targetPosition!,
            targetSize: targetSize!,
          )
        else
          _DimOverlay(),
        SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  color: Colors.black.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        if (tipText != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.tips_and_updates,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tipText!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: onNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(isLastStep ? 'Got it!' : 'Next'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DimOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}

class _SpotlightOverlay extends StatelessWidget {
  final Offset targetPosition;
  final Size targetSize;

  const _SpotlightOverlay({
    required this.targetPosition,
    required this.targetSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _DimOverlay(),
        _SpotlightCutout(
          targetPosition: targetPosition,
          targetSize: targetSize,
        ),
      ],
    );
  }
}

class _SpotlightCutout extends StatelessWidget {
  final Offset targetPosition;
  final Size targetSize;

  const _SpotlightCutout({
    required this.targetPosition,
    required this.targetSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _SpotlightPainter(
        targetPosition: targetPosition,
        targetSize: targetSize,
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset targetPosition;
  final Size targetSize;

  _SpotlightPainter({
    required this.targetPosition,
    required this.targetSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final spotlightRect = Rect.fromLTWH(
      targetPosition.dx - 16,
      targetPosition.dy - 16,
      targetSize.width + 32,
      targetSize.height + 32,
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(spotlightRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(spotlightRect, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return targetPosition != oldDelegate.targetPosition ||
        targetSize != oldDelegate.targetSize;
  }
}
