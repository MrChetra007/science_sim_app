import 'package:flutter/material.dart';
import 'package:science_lab/l10n/generated/app_localizations.dart';
import '../../core/physics/lorentz_engine.dart';

class VelocitySlider extends StatelessWidget {
  final double beta;
  final ValueChanged<double> onChanged;

  const VelocitySlider({
    super.key,
    required this.beta,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final gammaValue = LorentzEngine.gamma(beta);
    final sliderVal = LorentzEngine.betaToSlider(beta);

    final isApproachingC = beta > 0.95;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff15152a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff4fc3f7).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.relVelocityLabel((beta * 100).toStringAsFixed(1)),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.relLorentzFactor(gammaValue.toStringAsFixed(3)),
                style: const TextStyle(
                  color: Color(0xff00ff41),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 32,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xff4fc3f7),
                inactiveTrackColor: const Color(0xff4fc3f7).withOpacity(0.2),
                thumbColor: const Color(0xff4fc3f7),
                overlayColor: const Color(0xff4fc3f7).withOpacity(0.12),
                valueIndicatorColor: const Color(0xff4fc3f7),
              ),
              child: Slider(
                value: sliderVal,
                min: 0.0,
                max: 100.0,
                divisions: 100,
                onChanged: (val) {
                  final newBeta = LorentzEngine.sliderToBeta(val);
                  onChanged(newBeta);
                },
              ),
            ),
          ),
          if (isApproachingC)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xffff9800),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.relApproachingC,
                    style: TextStyle(
                      color: const Color(0xffff9800),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 16), // keep height stable
        ],
      ),
    );
  }
}
