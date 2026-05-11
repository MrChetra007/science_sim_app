import 'package:vector_math/vector_math_64.dart';
import '../models/vsepr_shape.dart';

final List<VseprShape> kVseprShapes = [
  VseprShape(
    id: 'linear', 
    bondingPairs: 2, 
    lonePairs: 0,
    bondAngle: '180°', 
    example: 'CO₂, BeCl₂',
    bondDirections: [Vector3(1, 0, 0), Vector3(-1, 0, 0)],
  ),
  VseprShape(
    id: 'trigonal_planar', 
    bondingPairs: 3, 
    lonePairs: 0,
    bondAngle: '120°', 
    example: 'BF₃, SO₃',
    bondDirections: [
      Vector3(1, 0, 0),
      Vector3(-0.5, 0.866, 0),
      Vector3(-0.5, -0.866, 0),
    ],
  ),
  VseprShape(
    id: 'bent_120', 
    bondingPairs: 2, 
    lonePairs: 1,
    bondAngle: '~120°', 
    example: 'SO₂, O₃',
    bondDirections: [
      Vector3(0.866, -0.5, 0),
      Vector3(-0.866, -0.5, 0),
    ],
    lonePairDirections: [Vector3(0, 1, 0)],
  ),
  VseprShape(
    id: 'tetrahedral', 
    bondingPairs: 4, 
    lonePairs: 0,
    bondAngle: '109.5°', 
    example: 'CH₄, SiH₄',
    bondDirections: [
      Vector3( 1,  1,  1)..normalize(),
      Vector3(-1, -1,  1)..normalize(),
      Vector3(-1,  1, -1)..normalize(),
      Vector3( 1, -1, -1)..normalize(),
    ],
  ),
  VseprShape(
    id: 'trigonal_pyramidal', 
    bondingPairs: 3, 
    lonePairs: 1,
    bondAngle: '107°', 
    example: 'NH₃, PCl₃',
    bondDirections: [
      Vector3( 1,   -0.3, 0)..normalize(),
      Vector3(-0.5, -0.3, 0.866)..normalize(),
      Vector3(-0.5, -0.3, -0.866)..normalize(),
    ],
    lonePairDirections: [Vector3(0, 1, 0)],
  ),
  VseprShape(
    id: 'bent_104', 
    bondingPairs: 2, 
    lonePairs: 2,
    bondAngle: '104.5°', 
    example: 'H₂O, H₂S',
    bondDirections: [
      Vector3(0.82, -0.57, 0)..normalize(),
      Vector3(-0.82, -0.57, 0)..normalize(),
    ],
    lonePairDirections: [
        Vector3(0, 0.5, 0.866)..normalize(),
        Vector3(0, 0.5, -0.866)..normalize(),
    ],
  ),
  VseprShape(
    id: 'octahedral', 
    bondingPairs: 6, 
    lonePairs: 0,
    bondAngle: '90°', 
    example: 'SF₆, PCl₆⁻',
    bondDirections: [
      Vector3(1, 0, 0), Vector3(-1, 0, 0),
      Vector3(0, 1, 0), Vector3(0, -1, 0),
      Vector3(0, 0, 1), Vector3(0, 0, -1),
    ],
  ),
];
