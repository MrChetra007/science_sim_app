import 'package:flutter/material.dart';
import '../services/iap_service.dart';
import '../../core/widgets/plan_picker.dart';

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
    showGlobalPlanDialog(context);
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
