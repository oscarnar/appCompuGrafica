import 'package:flutter/material.dart';
import 'package:grafica/screens/home.dart';
import 'package:grafica/screens/scanner.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    '/'           : (BuildContext context) => ImageCapture(),
    '/CamScanner' : (BuildContext context) => ScannerScreen(),
    //'/Contorn'    : (BuildContext context) => ContornPrueba(),
  };
}
