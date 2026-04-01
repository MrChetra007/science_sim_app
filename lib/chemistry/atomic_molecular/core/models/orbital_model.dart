import 'package:flutter/material.dart';

enum OrbitalType { s, px, py, pz, dxy, dxz, dyz, dz2, dx2y2 }

class OrbitalData {
  final OrbitalType type;
  final String label;
  final String description;
  final Color color;

  const OrbitalData({
    required this.type,
    required this.label,
    required this.description,
    required this.color,
  });
}

const List<OrbitalData> kOrbitals = [
  OrbitalData(
    type: OrbitalType.s,
    label: 's orbital',
    description: 'Spherically symmetrical probability region. Found in every energy level.',
    color: Color(0xFF5B8FFF),
  ),
  OrbitalData(
    type: OrbitalType.px,
    label: 'pₓ orbital',
    description: 'Dumbbell-shaped region aligned along the x-axis with a nodal plane at the nucleus.',
    color: Color(0xFF9B6EFF),
  ),
  OrbitalData(
    type: OrbitalType.py,
    label: 'pᵧ orbital',
    description: 'Dumbbell-shaped region aligned along the y-axis.',
    color: Color(0xFF9B6EFF),
  ),
  OrbitalData(
    type: OrbitalType.pz,
    label: 'p₂ orbital',
    description: 'Dumbbell-shaped region aligned along the z-axis (depth).',
    color: Color(0xFF9B6EFF),
  ),
  OrbitalData(
    type: OrbitalType.dxy,
    label: 'dₓᵧ orbital',
    description: 'Four-lobed clover shape lying in the xy-plane between the axes.',
    color: Color(0xFF3ECFA8),
  ),
  OrbitalData(
    type: OrbitalType.dz2,
    label: 'd₂² orbital',
    description: 'Unique two-lobed shape along the z-axis with a characteristic torus (donut) ring.',
    color: Color(0xFF3ECFA8),
  ),
  OrbitalData(
    type: OrbitalType.dx2y2,
    label: 'dₓ²₋ᵧ² orbital',
    description: 'Four-lobed shape lying along the x and y axes.',
    color: Color(0xFF3ECFA8),
  ),
];
