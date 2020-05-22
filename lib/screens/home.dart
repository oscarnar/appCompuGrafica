import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grafica/algorithms/contrastStretching.dart';
import 'package:grafica/algorithms/histogramEqualization.dart';
import 'package:grafica/dialogs/dialogContrast.dart';
import 'package:grafica/dialogs/dialogThresholding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grafica/utils/histogramUtil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'package:grafica/algorithms/operExponencial.dart';
import 'package:grafica/algorithms/operLogaritmo.dart';
import 'package:grafica/algorithms/thresholding.dart';
import 'package:grafica/algorithms/operRaiz.dart';
import 'package:grafica/dialogs/dialogRaiz.dart';
import 'package:grafica/dialogs/dialogExp.dart';
import 'package:grafica/dialogs/dialogLog.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;
  List<PointHist> histogram = List(256);

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    _imageFile = selected;
    await updateHistogram();

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> updateImage(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    _imageFile = File('${directory.path}/$name.jpg');
    await updateHistogram();

    setState(() {
      _imageFile = File('${directory.path}/$name.jpg');
    });
  }

  updateHistogram() {
    histogram = List(256);
    if (_imageFile != null) {
      img.Image ori = img.decodeImage(_imageFile.readAsBytesSync());
      int wi = ori.width;
      int he = ori.height;

      for (int x = 0; x < wi; x++) {
        for (int y = 0; y < he; y++) {
          int temp = img.getRed(ori[y * wi + x]);

          if (histogram[temp] == null) {
            histogram[temp] = PointHist(temp, 0);
          }
          histogram[temp].cant++;
        }
      }

      for (int x = 0; x < histogram.length; x++) {
        if (histogram[x] == null) {
          histogram[x] = PointHist(x, 0);
        }
      }
      //setState(() {});
    }
  }

  dialogHistogram(BuildContext context) {
    if (histogram[1] == null) {
      updateHistogram();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Histograma'),
            content: ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.all(20),
                  child: chart(histogram),
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Computacion Grafica'),
        actions: [
          IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () {
                dialogHistogram(context);
              })
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              buttonExp(context),
              buttonLog(context),
              buttonRaiz(context),
              buttonThresholding(context),
              buttonHistEqua(context),
              buttonConstrast(context),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            child: Icon(Icons.camera_alt),
            onPressed: () {
              _pickImage(ImageSource.camera);
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.image),
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Container(
              padding: EdgeInsets.all(5),
              child: chart(histogram),
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            Image.file(_imageFile),
          ],
        ],
      ),
    );
  }

  MaterialButton buttonLog(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Logaritmo '),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogLog(context).then(
          (value) {
            operLogaritmo(
              c: value[0].toInt(),
              imageFile: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonExp(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Exponencial'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogExp(context).then(
          (value) {
            operExponencial(
              c: value[0],
              b: value[1],
              imageFile: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonRaiz(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Raiz'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogRaiz(context).then(
          (value) {
            operRaiz(
              c: value[0].toInt(),
              imageFile: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonThresholding(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Thresholding'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogThre(context).then(
          (value) {
            thresholding(
              umbral: value[0].toInt(),
              imageFile: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonHistEqua(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Hist. Equali.'),
      onPressed: () {
        String now = DateTime.now().toString();
        histogramEqualization(
          histogram: histogram,
          imageFile: _imageFile,
          name: now,
        ).then((value) => updateImage(now));
      },
    );
  }

  MaterialButton buttonConstrast(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Constrast Stretching'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogContrast(context).then(
          (value) {
            contrastStretching(
              porcentaje: value[0],
              imageFile: _imageFile,
              name: now,
              histogram: histogram,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }
}
