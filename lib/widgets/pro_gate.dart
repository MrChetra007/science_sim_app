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

  static Future<void> showProModal(
    BuildContext context,
    String featureName,
  ) async {
    const double price = 3.99;
    return showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF040D17),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF00E5FF),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unlock $featureName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upgrade to Pro to access this technical tool and all advanced wave simulations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      await iapService.buyPro();
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'UNLOCK PRO ($price)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'MAYBE LATER',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<ProGate> createState() => _ProGateState();
}

class _ProGateState extends State<ProGate> {
  @override
  Widget build(BuildContext context) {
    if (iapService.isPro) {
      return widget.child;
    }

    return Stack(
      children: [
        AbsorbPointer(child: Opacity(opacity: 0.3, child: widget.child)),
        Positioned.fill(
          child: InkWell(
            onTap: () => ProGate.showProModal(
              context,
              widget.featureName,
            ).then((_) => setState(() {})),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF00E5FF),
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
