import 'package:flutter/material.dart';

abstract class Shape {
  bool isFinished = false;
  double rotation = 0;
  double scale = 1;

  void draw(Canvas canvas, Size size);
  void transform(double scale, double rotation);
  void move(Offset offset);
  bool cointainsTouchPoint(Offset offset);
}
