import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class MoleculeAtom {
  final String element; // symbol
  final Color color;
  final double radius;
  Vector3 position; // 3D coordinates in Angstroms

  MoleculeAtom({
    required this.element,
    required this.color,
    required this.radius,
    required this.position,
  });
}

class MoleculeBond {
  final int atomA;
  final int atomB;
  final int order; // 1=single, 2=double, 3=triple

  const MoleculeBond({
    required this.atomA,
    required this.atomB,
    required this.order,
  });
}

class Molecule {
  final String name;
  final String formula;
  final String shape;
  final String description;
  final List<MoleculeAtom> atoms;
  final List<MoleculeBond> bonds;

  const Molecule({
    required this.name,
    required this.formula,
    required this.shape,
    required this.description,
    required this.atoms,
    required this.bonds,
  });
}
