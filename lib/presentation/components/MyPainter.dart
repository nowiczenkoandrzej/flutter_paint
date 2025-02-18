import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Shape.dart';

class MyPainter extends CustomPainter {
  final List<Shape> shapes;

  MyPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    for (var shape in shapes) {
      shape.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
