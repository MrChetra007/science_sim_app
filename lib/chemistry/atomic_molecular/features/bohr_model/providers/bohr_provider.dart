import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/element.dart';
import '../../../core/constants/elements_data.dart';

final bohrProvider = StateNotifierProvider<BohrNotifier, ChemElement>((ref) {
  return BohrNotifier();
});

class BohrNotifier extends StateNotifier<ChemElement> {
  BohrNotifier() : super(kElements.first);

  int _maxIndex = kElements.length;

  int get maxIndex => _maxIndex;

  void setMaxIndex(int max) {
    _maxIndex = max;
    if (state.atomicNumber > max) {
      state = kElements.first;
    }
  }

  void select(ChemElement element) {
    if (element.atomicNumber <= _maxIndex) {
      state = element;
    }
  }
}
