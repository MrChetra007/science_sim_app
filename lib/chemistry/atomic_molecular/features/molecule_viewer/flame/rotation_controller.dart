import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class RotationController {
  v.Quaternion _rotation = v.Quaternion.identity();
  v.Quaternion _velocity = v.Quaternion.identity();
  v.Vector3 _lastDrag = v.Vector3.zero();

  void onDragStart(Offset pos) {
    _lastDrag = _projectOnSphere(pos);
    _velocity = v.Quaternion.identity();
  }

  void onDragUpdate(Offset pos) {
    final current = _projectOnSphere(pos);
    final delta = _rotationBetween(_lastDrag, current);
    _rotation = delta * _rotation;
    _velocity = delta;
    _lastDrag = current;
  }

  void applyInertia() {
    // Blend velocity toward identity (damping)
    // Manual LERP used here to avoid version-specific slerp/mix issues
    final q1 = v.Quaternion.identity();
    final q2 = _velocity;
    const t = 0.06; // Equivalent to 0.94 damping

    _velocity = v.Quaternion(
      q1.x + t * (q2.x - q1.x),
      q1.y + t * (q2.y - q1.y),
      q1.z + t * (q2.z - q1.z),
      q1.w + t * (q2.w - q1.w),
    )..normalize();

    _rotation = _velocity * _rotation;
    _rotation.normalize();
  }

  v.Matrix4 get rotationMatrix {
    final m3 = _rotation.asRotationMatrix();
    return v.Matrix4.identity()..setRotation(m3);
  }

  void reset() {
    _rotation = v.Quaternion.identity();
    _velocity = v.Quaternion.identity();
  }

  // Project 2D screen point onto a virtual sphere
  v.Vector3 _projectOnSphere(Offset pos) {
    // Normalize to -1.0 .. 1.0 range
    final x = (pos.dx / 150) - 1.0;
    final y = 1.0 - (pos.dy / 150);
    final z2 = 1.0 - x * x - y * y;
    final z = z2 > 0 ? sqrt(z2) : 0.0;
    return v.Vector3(x, y, z)..normalize();
  }

  v.Quaternion _rotationBetween(v.Vector3 a, v.Vector3 b) {
    final axis = a.cross(b)..normalize();
    final angle = acos(a.dot(b).clamp(-1.0, 1.0));
    return v.Quaternion.axisAngle(axis, angle);
  }
}
