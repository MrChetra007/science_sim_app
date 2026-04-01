import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/electrodes.dart';
import 'galvanic_state.dart';

part 'galvanic_provider.g.dart';

@riverpod
class GalvanicNotifier extends _$GalvanicNotifier {
  @override
  GalvanicState build() {
    return GalvanicState(
      anode: kElectrodes.first,    // Zn
      cathode: kElectrodes[4],     // Cu
    );
  }

  void setAnode(Electrode e) {
    state = _recalculate(state.copyWith(anode: e));
  }

  void setCathode(Electrode e) {
    state = _recalculate(state.copyWith(cathode: e));
  }

  GalvanicState _recalculate(GalvanicState s) {
    final ecell = s.cathode.reductionPotential - s.anode.reductionPotential;
    final n = _leastCommonElectrons(s.anode.electrons, s.cathode.electrons);
    
    // ΔG° = −nFE° (in kJ/mol, F = 96.485 C/mol)
    final dG = -n * 96.485 * ecell;

    return s.copyWith(
      cellPotential: ecell,
      electronCount: n,
      gibbsFreeEnergy: dG,
      isSpontaneous: ecell > 0,
      anodeReaction: '${s.anode.symbol} → ${s.anode.ion} + ${s.anode.electrons}e⁻',
      cathodeReaction: '${s.cathode.ion} + ${s.cathode.electrons}e⁻ → ${s.cathode.symbol}',
    );
  }

  int _leastCommonElectrons(int a, int b) {
    int max = a > b ? a : b;
    int lcm = max;
    while (lcm % a != 0 || lcm % b != 0) {
      lcm += max;
    }
    return lcm;
  }
}
