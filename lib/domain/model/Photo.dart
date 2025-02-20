import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Shape.dart';
import 'dart:ui' as ui;

class Photo extends Shape {
  final ui.Image img;
  Offset start;

  @override
  bool isFinished;

  Photo({required this.img, required this.isFinished, required this.start});

  @override
  void draw(Canvas canvas, Size size) {
    canvas.save(); // Zapisz stan canvasu
    canvas.translate(start.dx, start.dy); // Przesunięcie do punktu startowego
    canvas.scale(scale, scale); // Skalowanie
    canvas.rotate(rotation); // Obrót
    canvas.translate(-start.dx, -start.dy);

    canvas.drawImage(img, Offset.zero, Paint());

    canvas.restore();
  }

  @override
  void transform(double scale, double rotation) {
    this.scale *= scale;
    this.rotation *= rotation;
  }

  @override
  void move(Offset offset) {
    this.start = Offset(start.dx + offset.dx, start.dy + offset.dy);
  }

  @override // isnt needed bc not movable
  bool cointainsTouchPoint(Offset offset) {
    return offset.dx > start.dx &&
        offset.dx < img.width + start.dx &&
        offset.dy > start.dy &&
        offset.dy < img.height + start.dy;
  }
}
