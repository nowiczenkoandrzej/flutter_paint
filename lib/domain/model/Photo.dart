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
    canvas.drawImage(img, start, Paint());
  }

  @override
  void move(Offset offset) {
    this.start = Offset(start.dx + offset.dx, start.dy + offset.dy);
  }

  @override // isnt needed bc not movable
  bool cointainsTouchPoint(Offset offset) {
    return false;
  }
}
