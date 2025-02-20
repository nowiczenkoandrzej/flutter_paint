import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Shape.dart';

class Circle extends Shape {
  Offset center;
  double radius;
  Color color;
  @override
  bool isFinished;

  Circle(
      {required this.center,
      required this.radius,
      required this.color,
      required this.isFinished});

  double _calculateRadius(Offset p1, Offset p2) {
    return sqrt(pow((p1.dx - p2.dx), 2) + pow((p1.dy - p2.dy), 2));
  }

  @override
  bool cointainsTouchPoint(Offset offset) {
    return _calculateRadius(center, offset) < radius;
  }

  @override
  void transform(double scale, double rotation) {
    this.scale *= scale;
    this.rotation *= rotation;
  }

  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;

    canvas.save();
    canvas.translate(center.dx, center.dy); // Przesunięcie do środka figury
    canvas.scale(scale, scale); // Skalowanie
    canvas.rotate(rotation); // Obrót
    canvas.translate(-center.dx, -center.dy);

    canvas.drawCircle(center, radius, paint);

    canvas.restore();
  }

  @override
  void move(Offset offset) {
    this.center = Offset(center.dx + offset.dx, center.dy + offset.dy);
  }
}
