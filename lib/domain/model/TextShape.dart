

import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Shape.dart';

class TextShape extends Shape {
  String content;
  Offset start;
  final Color color;
  @override
  bool isFinished;

  TextShape(
      {required this.content,
      required this.start,
      required this.color,
      required this.isFinished});

  @override
  bool cointainsTouchPoint(Offset offset) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: content,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return offset.dx > start.dx &&
        offset.dx < start.dx + textPainter.width &&
        offset.dy > start.dy &&
        offset.dy < start.dy + textPainter.height;
  }

  @override
  void transform(double scale, double rotation) {
    this.scale *= scale;
    this.rotation *= rotation;
  }

  @override
  void draw(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: content,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    canvas.save(); // Zapisz stan canvasu
    canvas.translate(start.dx, start.dy); // Przesunięcie do punktu startowego
    canvas.scale(scale, scale); // Skalowanie
    canvas.rotate(rotation); // Obrót
    canvas.translate(
        -start.dx, -start.dy); // Powrót do oryginalnego układu współrzędnych

    // Narysuj tekst
    textPainter.paint(canvas, start);

    canvas.restore();
  }

  @override
  void move(Offset offset) {
    this.start = Offset(this.start.dx + offset.dx, this.start.dy + offset.dy);
  }
}
