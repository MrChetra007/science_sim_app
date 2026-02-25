import 'package:flutter/material.dart';
import '../services/iap_service.dart';

class ProGate extends StatefulWidget {
  final Widget child;
  final String featureName;

  const ProGate({
    super.key,
    required this.child,
    this.featureName = 'This feature',
  });

  @override
  State<ProGate> createState() => _ProGateState();
}

class _ProGateState extends State<ProGate> {
  final price = 3.99;

  @override
  Widget build(BuildContext context) {
    if (iapService.isPro) {
      return widget.child;
    }

    return Stack(
      children: [
        // Blurred/Dimmed content
        AbsorbPointer(child: Opacity(opacity: 0.3, child: widget.child)),

        // Lock Overlay
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF040D17).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF00E5FF),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  '${widget.featureName} is a Pro Feature',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await iapService.buyPro();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF00E5FF,
                    ).withValues(alpha: 0.1),
                    foregroundColor: const Color(0xFF00E5FF),
                    side: const BorderSide(color: Color(0xFF00E5FF)),
                  ),
                  child: Text('UNLOCK PRO (\$$price)'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
