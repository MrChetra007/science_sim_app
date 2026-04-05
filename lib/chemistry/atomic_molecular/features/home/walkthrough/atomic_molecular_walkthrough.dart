import 'package:flutter/material.dart';
import '../../../../../core/services/walkthrough_service.dart';
import '../../../../../core/widgets/walkthrough_tooltip.dart';

class AtomicMolecularWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? bohrKey;
  final GlobalKey? electronConfigKey;
  final GlobalKey? moleculeKey;
  final GlobalKey? vseprKey;
  final GlobalKey? orbitalKey;
  final GlobalKey? proKey;

  const AtomicMolecularWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.bohrKey,
    this.electronConfigKey,
    this.moleculeKey,
    this.vseprKey,
    this.orbitalKey,
    this.proKey,
  });

  @override
  State<AtomicMolecularWalkthrough> createState() => _AtomicMolecularWalkthroughState();
}

class _AtomicMolecularWalkthroughState extends State<AtomicMolecularWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "Atomic & Molecular Lab",
      description:
          "Explore atoms and molecules through interactive chemistry simulations. Visualize electron orbits, molecular shapes, and orbital probability regions.",
      tip: "Everything is made of atoms - understanding them is key to chemistry!",
    ),
    _WalkthroughStep(
      title: "Bohr Model (Pro)",
      description:
          "Watch electrons orbit the nucleus in animated shell models.",
      tip: "Select different elements to see how their electron configurations change!",
    ),
    _WalkthroughStep(
      title: "Electron Configuration",
      description:
          "Learn orbital filling rules and electron arrangements.",
      tip: "Electrons fill orbitals following the Aufbau principle - lowest energy first!",
    ),
    _WalkthroughStep(
      title: "3D Molecule Viewer",
      description:
          "Rotate and examine ball-and-stick molecular models.",
      tip: "Drag to rotate molecules and see their 3D structure from any angle!",
    ),
    _WalkthroughStep(
      title: "VSEPR Shapes",
      description:
          "Predict molecular geometry based on electron pair repulsion.",
      tip: "VSEPR helps predict the shape of molecules based on electron pairs!",
    ),
    _WalkthroughStep(
      title: "Orbital Viewer",
      description:
          "Explore s, p, d orbital probability regions.",
      tip: "Orbitals show where electrons are most likely to be found!",
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock Bohr Model and remove ads with premium.",
      tip: "Tap the stars icon to see subscription options!",
      isLastStep: true,
    ),
  ];

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.bohrKey;
      case 2:
        return widget.electronConfigKey;
      case 3:
        return widget.moleculeKey;
      case 4:
        return widget.vseprKey;
      case 5:
        return widget.orbitalKey;
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
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyAtomicMolecular);
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
