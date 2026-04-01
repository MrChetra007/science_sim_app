import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/molecule.dart';
import '../../../core/constants/molecules_data.dart';

final moleculeProvider = StateNotifierProvider<MoleculeNotifier, Molecule>((ref) {
  return MoleculeNotifier();
});

class MoleculeNotifier extends StateNotifier<Molecule> {
  MoleculeNotifier() : super(kMolecules.first);

  void select(Molecule molecule) {
    state = molecule;
  }
}
