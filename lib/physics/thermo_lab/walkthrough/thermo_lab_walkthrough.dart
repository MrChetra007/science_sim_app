import 'package:flutter/material.dart';
import '../../../core/widgets/walkthrough_tooltip.dart';

class ThermoLabWalkthrough extends StatefulWidget {
  final Widget child;
  final bool showWalkthrough;
  final VoidCallback? onComplete;
  final GlobalKey? heatTransferKey;
  final GlobalKey? gasLawsKey;
  final GlobalKey? carnotKey;
  final GlobalKey? phaseChangeKey;
  final GlobalKey? entropyKey;
  final GlobalKey? lawsKey;
  final GlobalKey? proKey;

  const ThermoLabWalkthrough({
    super.key,
    required this.child,
    required this.showWalkthrough,
    this.onComplete,
    this.heatTransferKey,
    this.gasLawsKey,
    this.carnotKey,
    this.phaseChangeKey,
    this.entropyKey,
    this.lawsKey,
    this.proKey,
  });

  @override
  State<ThermoLabWalkthrough> createState() => _ThermoLabWalkthroughState();
}

class _ThermoLabWalkthroughState extends State<ThermoLabWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "Thermo Lab",
      description:
          "Explore thermodynamics through interactive simulations. Learn about heat transfer, gas laws, and entropy.",
      tip: "Thermodynamics is the study of heat and energy flow!",
    ),
    _WalkthroughStep(
      title: "Heat Transfer",
      description:
          "Learn about conduction, convection, and radiation. See how heat moves through different materials.",
      tip: "Conduction: heat transfer through direct contact",
      targetKey: 'heat',
    ),
    _WalkthroughStep(
      title: "Gas Laws",
      description:
          "Explore Boyle's, Charles's, and Gay-Lussac's laws. Understand the relationship between pressure, volume, and temperature.",
      tip: "PV = nRT: The ideal gas law!",
      targetKey: 'gas',
    ),
    _WalkthroughStep(
      title: "Carnot Engine",
      description:
          "Learn about the most efficient heat engine possible. See how temperature differences drive work.",
      tip: "No real engine can be 100% efficient!",
      targetKey: 'carnot',
    ),
    _WalkthroughStep(
      title: "Phase Change",
      description:
          "Watch matter change between solid, liquid, and gas states. See the heating curve in action.",
      tip: "Melting and boiling happen at constant temperature!",
      targetKey: 'phase',
    ),
    _WalkthroughStep(
      title: "Entropy",
      description:
          "Explore the second law of thermodynamics. See how disorder increases over time.",
      tip: "Entropy always increases in isolated systems!",
      targetKey: 'entropy',
    ),
    _WalkthroughStep(
      title: "Laws of Thermo",
      description:
          "Read about the zeroth, first, second, and third laws of thermodynamics.",
      tip: "Energy can neither be created nor destroyed!",
      targetKey: 'laws',
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock Heat Transfer and Gas Laws with a premium subscription. Remove ads too!",
      tip: "Tap the stars icon to see subscription options!",
      isLastStep: true,
    ),
  ];

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.heatTransferKey;
      case 2:
        return widget.gasLawsKey;
      case 3:
        return widget.carnotKey;
      case 4:
        return widget.phaseChangeKey;
      case 5:
        return widget.entropyKey;
      case 6:
        return widget.lawsKey;
      case 7:
        return widget.proKey;
      default:
        return null;
    }
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _completeWalkthrough();
    }
  }

  void _completeWalkthrough() {
    widget.onComplete?.call();
    if (mounted) {
      setState(() => _currentStep = 0);
    }
  }

  void _skip() {
    _completeWalkthrough();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showWalkthrough) ...[
          if (_currentStep > 0 && _currentStep < _steps.length - 1)
            Positioned.fill(
              child: GestureDetector(
                onTap: _nextStep,
                child: Container(color: Colors.black54),
              ),
            ),
          if (_currentStep > 0 && _currentStep < _steps.length - 1)
            _buildTooltip(),
          if (_currentStep == 0 && _steps.isNotEmpty)
            _buildWelcomeTooltip(),
        ],
      ],
    );
  }

  Widget _buildWelcomeTooltip() {
    final step = _steps[0];
    return WalkthroughTooltip(
      title: step.title,
      description: step.description,
      tipText: step.tip,
      onNext: _nextStep,
      onSkip: _skip,
      isLastStep: _steps.length == 1,
    );
  }

  Widget _buildTooltip() {
    final step = _steps[_currentStep];
    
    return WalkthroughTooltip(
      title: step.title,
      description: step.description,
      tipText: step.tip,
      onNext: _nextStep,
      onSkip: _skip,
      isLastStep: step.isLastStep,
    );
  }
}

class _WalkthroughStep {
  final String title;
  final String description;
  final String tip;
  final String? targetKey;
  final bool isLastStep;

  _WalkthroughStep({
    required this.title,
    required this.description,
    required this.tip,
    this.targetKey,
    this.isLastStep = false,
  });
}
