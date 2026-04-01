import 'package:vector_math/vector_math_64.dart';
import '../models/vsepr_shape.dart';

final List<VseprShape> kVseprShapes = [
  VseprShape(
    name: 'Linear', 
    bondingPairs: 2, 
    lonePairs: 0,
    bondAngle: '180°', 
    example: 'CO₂, BeCl₂',
    description: 'Two bonding pairs, zero lone pairs. Atoms are arranged in a straight line for maximum separation.',
    bondDirections: [Vector3(1, 0, 0), Vector3(-1, 0, 0)],
  ),
  VseprShape(
    name: 'Trigonal Planar', 
    bondingPairs: 3, 
    lonePairs: 0,
    bondAngle: '120°', 
    example: 'BF₃, SO₃',
    description: 'Three bonds in a flat plane, equally spaced at 120° angles to minimize repulsion.',
    bondDirections: [
      Vector3(1, 0, 0),
      Vector3(-0.5, 0.866, 0),
      Vector3(-0.5, -0.866, 0),
    ],
  ),
  VseprShape(
    name: 'Bent (120°)', 
    bondingPairs: 2, 
    lonePairs: 1,
    bondAngle: '~120°', 
    example: 'SO₂, O₃',
    description: 'Two bonds and one lone pair. The lone pair pushes the bonds closer than 120°.',
    bondDirections: [
      Vector3(0.866, -0.5, 0),
      Vector3(-0.866, -0.5, 0),
    ],
    lonePairDirections: [Vector3(0, 1, 0)],
  ),
  VseprShape(
    name: 'Tetrahedral', 
    bondingPairs: 4, 
    lonePairs: 0,
    bondAngle: '109.5°', 
    example: 'CH₄, SiH₄',
    description: 'Four bonds pointing to the corners of a regular tetrahedron. Highly symmetrical.',
    bondDirections: [
      Vector3( 1,  1,  1)..normalize(),
      Vector3(-1, -1,  1)..normalize(),
      Vector3(-1,  1, -1)..normalize(),
      Vector3( 1, -1, -1)..normalize(),
    ],
  ),
  VseprShape(
    name: 'Trigonal Pyramidal', 
    bondingPairs: 3, 
    lonePairs: 1,
    bondAngle: '107°', 
    example: 'NH₃, PCl₃',
    description: 'Three bonds + one lone pair. The lone pair occupies more space, compressing bond angles.',
    bondDirections: [
      Vector3( 1,   -0.3, 0)..normalize(),
      Vector3(-0.5, -0.3, 0.866)..normalize(),
      Vector3(-0.5, -0.3, -0.866)..normalize(),
    ],
    lonePairDirections: [Vector3(0, 1, 0)],
  ),
  VseprShape(
    name: 'Bent (104.5°)', 
    bondingPairs: 2, 
    lonePairs: 2,
    bondAngle: '104.5°', 
    example: 'H₂O, H₂S',
    description: 'Two bonds + two lone pairs. Two lone pairs provide maximum compression on the bonds.',
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
    name: 'Octahedral', 
    bondingPairs: 6, 
    lonePairs: 0,
    bondAngle: '90°', 
    example: 'SF₆, PCl₆⁻',
    description: 'Six bonds pointing to the faces of a regular cube. All bond angles are 90°.',
    bondDirections: [
      Vector3(1, 0, 0), Vector3(-1, 0, 0),
      Vector3(0, 1, 0), Vector3(0, -1, 0),
      Vector3(0, 0, 1), Vector3(0, 0, -1),
    ],
  ),
];
