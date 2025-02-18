import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Shape.dart';

class Line extends Shape {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  @override
  bool isFinished;

  Line(
      {required this.points,
      required this.color,
      required this.strokeWidth,
      required this.isFinished});

  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override // not movable
  void move(Offset offset) {
    return;
  }

  @override // isnt needed bc not movable
  bool cointainsTouchPoint(Offset offset) {
    return false;
  }
}
