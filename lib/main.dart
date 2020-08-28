import 'package:flutter/material.dart';
//import 'package:grafica/components/crop_image.dart';
import 'package:grafica/providers/imageProvider.dart';
import 'package:grafica/routes.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ImagenProvider>(
          create: (_) => ImagenProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        routes: getRoutes(),
        //home: ImageCapture(),//MyHomePage(),
        initialRoute: '/',
      ),
    );
  }
}
