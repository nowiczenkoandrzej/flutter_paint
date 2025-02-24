import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/Circle.dart';
import 'package:paint_v2/domain/model/Line.dart';
import 'package:paint_v2/domain/model/Photo.dart';
import 'package:paint_v2/domain/model/Shape.dart';
import 'package:paint_v2/domain/model/ShapeType.dart';
import 'package:paint_v2/domain/model/TextShape.dart';
import 'package:paint_v2/domain/model/Rectangle.dart';
import 'package:paint_v2/presentation/components/AddTextDialog.dart';
import 'package:paint_v2/presentation/components/MyPainter.dart';
import 'package:paint_v2/presentation/components/ShapeSelector.dart';

class FullScreenCanvas extends StatefulWidget {
  @override
  _FullScreenCanvasState createState() => _FullScreenCanvasState();
}

class _FullScreenCanvasState extends State<FullScreenCanvas> {
  ShapeType? selectedShape = null;
  int? selectedElementIndex = null;
  Offset? previousOffset = null;
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  final _controller = TextEditingController();
  double _previousScale = 1.0;
  double _previousRotation = 0.0;

  bool isGestureStarted = false;

  Offset? lastOffset;

  List<Shape> shapes = [];
  List<Shape> undos = [];

  void handleShapeSelect(ShapeType? shape) {
    setState(() {
      selectedShape = shape;
    });
  }

  void handleColorSelect(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void pickImage(ui.Image image) {
    var newImg = Photo(start: Offset.zero, img: image, isFinished: true);

    setState(() {
      shapes.add(newImg);
    });
  }

  void onSaveText(Offset offset) {
    setState(() {
      shapes.add(TextShape(
          content: _controller.text,
          color: selectedColor,
          start: offset,
          isFinished: false));
    });
    Navigator.of(context).pop();
    _controller.clear();
  }

  void drawShape(ScaleUpdateDetails details) {
    switch (selectedShape) {
      case ShapeType.PENCIL:
        setState(() {
          _drawPencil(details);
        });
      case ShapeType.CIRCLE:
        setState(() {
          _drawCircle(details);
        });
      case ShapeType.RECT:
        setState(() {
          _updateRect(details);
        });

      case ShapeType.TEXT:
        setState(() {
          _drawText(details);
        });
      case null:
        for (int i = 0; i < shapes.length; i++) {
          if (shapes[i].cointainsTouchPoint(details.focalPoint)) {
            selectedElementIndex = i;
          }
        }
    }
  }

  void _drawPencil(ScaleUpdateDetails details) {
    if (shapes.isNotEmpty && shapes.last is Line) {
      if (!shapes.last.isFinished) {
        (shapes.last as Line).points.add(details.localFocalPoint);
      } else {
        shapes.add(Line(
            points: [details.localFocalPoint],
            color: selectedColor,
            strokeWidth: 5,
            isFinished: false));
      }
    } else {
      shapes.add(Line(
          points: [details.localFocalPoint],
          color: selectedColor,
          strokeWidth: 5,
          isFinished: false));
    }
  }

  void _drawCircle(ScaleUpdateDetails details) {
    if (shapes.isNotEmpty && shapes.last is Circle && !shapes.last.isFinished) {
      (shapes.last as Circle).radius = _calculateRadius(
          (shapes.last as Circle).center, details.localFocalPoint);
    } else {
      shapes.add(Circle(
          center: details.localFocalPoint,
          radius: 0,
          color: selectedColor,
          isFinished: false));
    }
  }

  void _updateRect(ScaleUpdateDetails details) {
    if (shapes.isNotEmpty && shapes.last is Rectangle) {
      if (!shapes.last.isFinished) {
        double top = (shapes.last as Rectangle).rect.top;
        double bottom = (shapes.last as Rectangle).rect.bottom;
        double left = (shapes.last as Rectangle).rect.left;
        double right = (shapes.last as Rectangle).rect.right;

        if ((shapes.last as Rectangle).rect.center.dy <
            details.localFocalPoint.dy) {
          bottom = details.localFocalPoint.dy;
        } else {
          top = details.localFocalPoint.dy;
        }

        if ((shapes.last as Rectangle).rect.center.dx <
            details.localFocalPoint.dx) {
          right = details.localFocalPoint.dx;
        } else {
          left = details.localFocalPoint.dx;
        }

        Rect newRect = Rect.fromLTRB(left, top, right, bottom);

        (shapes.last as Rectangle).rect = newRect;
      } else {
        Rect newRect =
            Rect.fromPoints(details.localFocalPoint, details.localFocalPoint);
        shapes.add(
            Rectangle(rect: newRect, color: selectedColor, isFinished: false));
      }
    } else {
      Rect newRect =
          Rect.fromPoints(details.localFocalPoint, details.localFocalPoint);
      shapes.add(
          Rectangle(rect: newRect, color: selectedColor, isFinished: false));
    }
  }

  void _drawText(ScaleUpdateDetails details) {
    if (shapes.isNotEmpty &&
        shapes.last is TextShape &&
        !shapes.last.isFinished) {
      (shapes.last as TextShape).start = details.localFocalPoint;
    }
  }

  void changeColor(Color color) => setState(() => pickerColor = color);

  double _calculateRadius(Offset p1, Offset p2) =>
      sqrt(pow((p1.dx - p2.dx), 2) + pow((p1.dy - p2.dy), 2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            if (selectedShape == ShapeType.TEXT) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AddTextDialog(
                      controller: _controller,
                      onSave: () => onSaveText(details.localPosition),
                      onCancel: () => Navigator.of(context).pop(),
                    );
                  });
            }
          },
          onScaleStart: (ScaleStartDetails details) {
            if (selectedElementIndex == null) {
              Offset start = details.focalPoint;

              isGestureStarted = true;
              if (selectedShape == null) {
                for (int i = shapes.length - 1; i >= 0; i--) {
                  if (shapes[i].cointainsTouchPoint(start)) {
                    setState(() {
                      selectedElementIndex = i;
                    });

                    _previousRotation = shapes[i].rotation;
                    _previousScale = shapes[i].scale;

                    break;
                  }
                }
              }
            }
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            if (selectedElementIndex != null) {
              setState(() {
                shapes[selectedElementIndex!].move(details.focalPointDelta);
                shapes[selectedElementIndex!].scale =
                    _previousScale * details.scale;
                shapes[selectedElementIndex!].rotation =
                    _previousRotation + details.rotation;

                lastOffset = details.focalPoint;

                print(details.scale);
                print(details.rotation);
              });
            } else {
              drawShape(details);
            }
          },
          onScaleEnd: (ScaleEndDetails details) {
            // setState(() {
            //   shapes = shapes;
            // });

            if (selectedElementIndex != null &&
                lastOffset != null &&
                lastOffset!.dx > MediaQuery.of(context).size.width - 40 &&
                lastOffset!.dy > MediaQuery.of(context).size.height - 40) {
              setState(() {
                shapes.removeAt(selectedElementIndex!);
              });
            }
            setState(() {
              selectedElementIndex = null;
            });
            if (shapes.isNotEmpty) shapes.last.isFinished = true;
            lastOffset = null;
            isGestureStarted = false;
            undos.clear();
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: MyPainter(shapes),
          ),
        ),
        Positioned(
            top: 36,
            right: 16,
            child: Shapeselector(
              onSelectColor: handleColorSelect,
              onSelectShape: handleShapeSelect,
              selectedShape: selectedShape,
              onImagePicked: pickImage,
              selectedColor: selectedColor,
            )),
        Positioned(
            top: 36,
            left: 16,
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  setState(() {
                    if (shapes.isNotEmpty) {
                      final lastShape = shapes.removeLast();
                      undos.add(lastShape);
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  setState(() {
                    if (undos.isNotEmpty) {
                      final lastUndo = undos.removeLast();
                      shapes.add(lastUndo);
                    }
                  });
                },
              ),
            ])),
        Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                if (selectedElementIndex != null) Icon(Icons.delete),
              ],
            )),
      ]),
    );
  }
}
