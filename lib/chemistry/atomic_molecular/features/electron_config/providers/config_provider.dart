import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/element.dart';
import '../../../core/constants/elements_data.dart';
import '../../../core/utils/config_builder.dart';

final configProvider = StateNotifierProvider<ConfigNotifier, ConfigState>((ref) {
  return ConfigNotifier();
});

class ConfigState {
  final ChemElement element;
  final List<OrbitalFill> fills;
  final String notation;

  ConfigState({
    required this.element,
    required this.fills,
    required this.notation,
  });

  ConfigState copyWith({ChemElement? element, List<OrbitalFill>? fills, String? notation}) {
    return ConfigState(
      element: element ?? this.element,
      fills: fills ?? this.fills,
      notation: notation ?? this.notation,
    );
  }
}

class ConfigNotifier extends StateNotifier<ConfigState> {
  ConfigNotifier() : super(_buildInitialState());

  static ConfigState _buildInitialState() {
    final el = kElements.first;
    final fills = ConfigBuilder.buildConfig(el.atomicNumber);
    final notation = ConfigBuilder.toNotation(fills);
    return ConfigState(element: el, fills: fills, notation: notation);
  }

  void selectElement(ChemElement el) {
    final fills = ConfigBuilder.buildConfig(el.atomicNumber);
    final notation = ConfigBuilder.toNotation(fills);
    state = ConfigState(element: el, fills: fills, notation: notation);
  }
}
