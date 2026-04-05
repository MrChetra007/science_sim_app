import 'package:flutter/material.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/walkthrough_tooltip.dart';

class ACLabWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? oscilloscopeKey;
  final GlobalKey? transformerKey;
  final GlobalKey? rlcKey;
  final GlobalKey? controlPanelKey;
  final GlobalKey? gameViewKey;
  final GlobalKey? proKey;

  const ACLabWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.oscilloscopeKey,
    this.transformerKey,
    this.rlcKey,
    this.controlPanelKey,
    this.gameViewKey,
    this.proKey,
  });

  @override
  State<ACLabWalkthrough> createState() => _ACLabWalkthroughState();
}

class _ACLabWalkthroughState extends State<ACLabWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "AC Electricity Lab",
      description:
          "Explore alternating current concepts through interactive visualizations. See sine waves, phasors, and electrical components in action.",
      tip: "AC changes direction periodically - watch the electrons flow back and forth!",
    ),
    _WalkthroughStep(
      title: "Live Visualization",
      description:
          "Watch the AC waveform animation showing voltage and current cycling in real-time.",
      tip: "The sine wave shows how voltage rises and falls, changing direction!",
    ),
    _WalkthroughStep(
      title: "Oscilloscope Mode",
      description:
          "View detailed waveforms and measure peak voltage and frequency.",
      tip: "Tap the chart icon to open the oscilloscope for precise measurements!",
    ),
    _WalkthroughStep(
      title: "Transformer Lab",
      description:
          "Learn about voltage transformation with primary and secondary coils.",
      tip: "Transformers can step voltage up or down using electromagnetic induction!",
    ),
    _WalkthroughStep(
      title: "RLC Reactive Lab",
      description:
          "Explore inductance, capacitance, and impedance in AC circuits.",
      tip: "These components affect how AC current flows at different frequencies!",
    ),
    _WalkthroughStep(
      title: "Control Panel",
      description:
          "Adjust frequency, amplitude, and other parameters to see how they affect the waveform.",
      tip: "Try increasing frequency to see the waveform compress!",
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock all labs and remove ads with a premium subscription.",
      tip: "Tap the stars icon to see subscription options!",
      isLastStep: true,
    ),
  ];

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.gameViewKey;
      case 2:
        return widget.oscilloscopeKey;
      case 3:
        return widget.transformerKey;
      case 4:
        return widget.rlcKey;
      case 5:
        return widget.controlPanelKey;
      case 6:
        return widget.proKey;
      default:
        return null;
    }
  }

  Offset? _getStepPosition(int step) {
    final key = _getKeyForStep(step);
    if (key?.currentContext == null) return null;

    final box = key!.currentContext!.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero);
  }

  Size? _getStepSize(int step) {
    final key = _getKeyForStep(step);
    if (key?.currentContext == null) return null;

    final box = key!.currentContext!.findRenderObject() as RenderBox;
    return box.size;
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _complete();
    }
  }

  void _complete() {
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyAcLab);
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Stack(
      children: [
        widget.child,
        WalkthroughTooltip(
          title: step.title,
          description: step.description,
          tipText: step.tip,
          isLastStep: step.isLastStep,
          onNext: _nextStep,
          onSkip: _complete,
          targetPosition: _getStepPosition(_currentStep),
          targetSize: _getStepSize(_currentStep),
        ),
      ],
    );
  }
}

class _WalkthroughStep {
  final String title;
  final String description;
  final String tip;
  final bool isLastStep;

  _WalkthroughStep({
    required this.title,
    required this.description,
    required this.tip,
    this.isLastStep = false,
  });
}
