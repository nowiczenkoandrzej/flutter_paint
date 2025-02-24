import 'package:flutter/material.dart';
import 'package:paint_v2/presentation/FullScreenCanvas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FullScreenCanvas(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}














