
import 'package:flutter/material.dart';
import 'package:grafica/components/crop_image.dart';
import 'package:grafica/routes.dart';
import 'package:grafica/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      routes: getRoutes(),
      //home: ImageCapture(),//MyHomePage(),
      initialRoute: '/',
    );
  }
}
