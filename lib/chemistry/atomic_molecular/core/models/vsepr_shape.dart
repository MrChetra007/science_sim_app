import 'package:vector_math/vector_math_64.dart';

class VseprShape {
  final String name; // e.g. "Tetrahedral"
  final int bondingPairs;
  final int lonePairs;
  final String bondAngle;
  final String example;
  final String description;
  final List<Vector3> bondDirections; // unit vectors for bonds
  final List<Vector3>? lonePairDirections; // unit vectors for lone pairs

  const VseprShape({
    required this.name,
    required this.bondingPairs,
    required this.lonePairs,
    required this.bondAngle,
    required this.example,
    required this.description,
    required this.bondDirections,
    this.lonePairDirections,
  });

  int get stericNumber => bondingPairs + lonePairs;
}
