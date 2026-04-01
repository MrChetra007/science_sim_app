import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/vsepr_shape.dart';
import '../../../core/constants/vsepr_data.dart';

final vseprProvider = StateNotifierProvider<VseprNotifier, VseprShape>((ref) {
  return VseprNotifier();
});

class VseprNotifier extends StateNotifier<VseprShape> {
  VseprNotifier() : super(kVseprShapes.first);

  void select(VseprShape shape) {
    state = shape;
  }
}
