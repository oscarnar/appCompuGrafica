import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grafica/algorithms/operLogaritmo.dart';
import 'package:grafica/algorithms/thresholding.dart';
import 'package:grafica/dialogs/dialogExp.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:opencv/opencv.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'dialogs/dialogLog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ImageCapture(),
    );
  }
}

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<int> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thresholding'),
          content: TextField(
            controller: customController,
            keyboardType: TextInputType.number,
          ),
          actions: [
            MaterialButton(
              elevation: 5,
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(int.parse(customController.text));
              },
            )
          ],
        );
      },
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> updateImage(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _imageFile = File('${directory.path}/$name.jpg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algoritmos de Computacion Grafica'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(Icons.sentiment_very_satisfied),
              onPressed: () {
                String now = DateTime.now().toString();
                dialogExp(context).then((value) {
                  thresholding(
                    umbral: value[0].toInt(),
                    imageFile: _imageFile,
                    name: now,
                  );
                  updateImage(now);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.blur_on),
              onPressed: () {
                String now = DateTime.now().toString();
                dialogLog(context).then((value) {
                  operLogaritmo(
                    c: value[0].toInt(),
                    imageFile: _imageFile,
                    name: now,
                  );
                  updateImage(now);
                });
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
          ],
        ],
      ),
    );
  }
}

