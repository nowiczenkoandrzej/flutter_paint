import 'package:flutter/material.dart';
import 'package:paint_v2/domain/model/ShapeType.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;

class Shapeselector extends StatefulWidget {
  final void Function(Color) onSelectColor;
  final void Function(ShapeType?) onSelectShape;
  final void Function(ui.Image) onImagePicked;
  final ShapeType? selectedShape;

  const Shapeselector(
      {super.key,
      required this.onSelectColor,
      required this.onSelectShape,
      required this.selectedShape,
      required this.onImagePicked});

  @override
  State<Shapeselector> createState() => _ShapeselectorState();
}

class _ShapeselectorState extends State<Shapeselector> {
  Future _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile!.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      widget.onImagePicked(frame.image);
      widget.onSelectShape(null);
    }
  }

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
          onPressed: () async {
            _pickImage();
          },
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
