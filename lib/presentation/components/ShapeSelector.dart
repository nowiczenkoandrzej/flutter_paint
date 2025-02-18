import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/ShapeType.dart';

class Shapeselector extends StatefulWidget {
  final void Function(Color) onSelectColor;
  final void Function(ShapeType?) onSelectShape;
  final ShapeType? selectedShape;

  const Shapeselector(
      {super.key,
      required this.onSelectColor,
      required this.onSelectShape,
      required this.selectedShape});

  @override
  State<Shapeselector> createState() => _ShapeselectorState();
}

class _ShapeselectorState extends State<Shapeselector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'save':
                //selectedShape = ShapeType.PENCIL;
                case 'new':
                //selectedShape = ShapeType.CIRCLE;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'save',
                      child: ListTile(
                          leading: Icon(Icons.save), title: Text('Save'))),
                  const PopupMenuItem<String>(
                      value: 'new',
                      child: ListTile(
                          leading: Icon(Icons.new_label), title: Text('New'))),
                ]),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.color_lens),
        ),
        IconButton(
          onPressed: () {
            widget.onSelectShape(ShapeType.TEXT);
          },
          icon: Icon(Icons.text_fields),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.image_outlined),
        ),
        IconButton(
          onPressed: () {
            widget.onSelectShape(ShapeType.RECT);
          },
          icon: Icon(Icons.rectangle_outlined),
        ),
        IconButton(
          onPressed: () {
            widget.onSelectShape(ShapeType.CIRCLE);
          },
          icon: Icon(Icons.circle_outlined),
        ),
        IconButton(
          onPressed: () {
            widget.onSelectShape(ShapeType.PENCIL);
          },
          icon: Icon(Icons.line_axis_rounded),
        ),
        if (widget.selectedShape != null)
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.onSelectShape(null);
            },
          ),
      ],
    );
  }
}
