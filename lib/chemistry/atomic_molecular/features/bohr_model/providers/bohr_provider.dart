import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/element.dart';
import '../../../core/constants/elements_data.dart';

final bohrProvider = StateNotifierProvider<BohrNotifier, ChemElement>((ref) {
  return BohrNotifier();
});

class BohrNotifier extends StateNotifier<ChemElement> {
  BohrNotifier() : super(kElements.first);

  void select(ChemElement element) {
    state = element;
  }
}
