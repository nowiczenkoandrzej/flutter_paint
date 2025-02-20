import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Shape.dart';

class Rectangle extends Shape {
  Rect rect;
  final Color color;
  @override
  bool isFinished;

  Rectangle({
    required this.rect,
    required this.color,
    required this.isFinished,
  });

  @override
  bool cointainsTouchPoint(Offset offset) {
    return offset.dx > rect.left &&
        offset.dx < rect.right &&
        offset.dy > rect.top &&
        offset.dy < rect.bottom;
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
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.scale(scale, scale);
    canvas.rotate(rotation);
    canvas.translate(-rect.center.dx, -rect.center.dy);

    canvas.drawRect(rect, paint);

    canvas.restore();
  }

  @override
  void move(Offset offset) {
    Rect newRect = Rect.fromLTRB(rect.left + offset.dx, rect.top + offset.dy,
        rect.right + offset.dx, rect.bottom + offset.dy);
    this.rect = newRect;
  }
}
