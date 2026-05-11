import 'package:vector_math/vector_math_64.dart';

class VseprShape {
  final String id; // e.g. "tetrahedral" - used for localization lookup
  final int bondingPairs;
  final int lonePairs;
  final String bondAngle;
  final String example;
  final List<Vector3> bondDirections; // unit vectors for bonds
  final List<Vector3>? lonePairDirections; // unit vectors for lone pairs

  const VseprShape({
    required this.id,
    required this.bondingPairs,
    required this.lonePairs,
    required this.bondAngle,
    required this.example,
    required this.bondDirections,
    this.lonePairDirections,
  });

  int get stericNumber => bondingPairs + lonePairs;
}
