import '../providers/wave_provider.dart';

class WaveAnnotationSet {
  final bool showAmplitude;
  final bool showWavelength;
  final bool showPeriod;
  final bool showVelocity;
  final bool showNodes;
  final bool showHarmonicBadge;
  final bool showPhaseBadge;
  final bool showResultantA;
  final bool showDopplerAsymmetry;

  const WaveAnnotationSet({
    this.showAmplitude = false,
    this.showWavelength = false,
    this.showPeriod = false,
    this.showVelocity = false,
    this.showNodes = false,
    this.showHarmonicBadge = false,
    this.showPhaseBadge = false,
    this.showResultantA = false,
    this.showDopplerAsymmetry = false,
  });

  factory WaveAnnotationSet.forMode(WaveMode mode, WaveType type) {
    switch (mode) {
      case WaveMode.simulation:
        return const WaveAnnotationSet(
          showAmplitude: true,
          showWavelength: true,
          showPeriod: true,
          showVelocity: true,
        );
      case WaveMode.standing:
        return const WaveAnnotationSet(
          showAmplitude: true,
          showWavelength: true,
          showNodes: true,
          showHarmonicBadge: true,
        );
      case WaveMode.interference:
        return const WaveAnnotationSet(
          showAmplitude: true,
          showPhaseBadge: true,
          showResultantA: true,
        );
      case WaveMode.doppler:
        return const WaveAnnotationSet(
          showAmplitude: true,
          showVelocity: true,
          showDopplerAsymmetry: true,
        );
      case WaveMode.travelling:
        return const WaveAnnotationSet(
          showAmplitude: true,
          showWavelength: true,
          showVelocity: true,
        );
    }
  }
}
