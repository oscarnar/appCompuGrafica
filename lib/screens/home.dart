import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grafica/algorithms/adicion.dart';
import 'package:grafica/algorithms/blending.dart';
import 'package:grafica/algorithms/contrastStretching.dart';
import 'package:grafica/algorithms/division.dart';
import 'package:grafica/algorithms/histogramEqualization.dart';
import 'package:grafica/algorithms/logical.dart';
import 'package:grafica/algorithms/multiplicacion.dart';
import 'package:grafica/algorithms/resta.dart';
import 'package:grafica/components/crop_image.dart';
import 'package:grafica/dialogs/dialogBlending.dart';
import 'package:grafica/dialogs/dialogContrast.dart';
import 'package:grafica/dialogs/dialogMulti.dart';
import 'package:grafica/dialogs/dialogThresholding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grafica/screens/scanner.dart';
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
  bool isCropImage = false;
  List<PointHist> histogram = List(256);

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    _imageFile = selected;
    await updateHistogram();

    setState(() {
      _imageFile = selected;
    });
  }

  Future<File> pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    return selected;
  }

  Future<void> saveImage(String name) async {
    final directory = await getTemporaryDirectory();//getDownloadsDirectory();
    _imageFile.copy('${directory.path}/$name.jpg');
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
        title: Text('Computación Grafica'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              String now = DateTime.now().toString();
              //saveImage(now);
              Navigator.pushNamed(context, '/Contorn');
            },
          ),
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {
              // Dialog scanner
              Navigator.pushNamed(context, '/CamScanner');
            },
          ),
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
              buttonAdicion(context),
              buttonResta(context),
              buttonMultiplicacion(context),
              buttonDivision(context),
              buttonBlending(context),
              buttonLogical(context),
              buttonCrop(context),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "floating11",
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
            heroTag: "floating12",
            child: Icon(Icons.image),
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          if (isCropImage == true && _imageFile != null) ...[
            //CropImage(),
          ],
          if (_imageFile != null && isCropImage == false) ...[
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
              umbral: value,
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

  MaterialButton buttonAdicion(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Adicion'),
      onPressed: () {
        String now = DateTime.now().toString();
        pickImage(ImageSource.gallery).then(
          (value) {
            operAdicion(
              imageFile2: value,
              imageFile: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonResta(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Resta'),
      onPressed: () {
        String now = DateTime.now().toString();
        pickImage(ImageSource.gallery).then(
          (value) {
            operResta(
              imageFile2: value,
              imageFile: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonMultiplicacion(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Multi'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogMulti(context).then(
          (value) {
            operMulti(
              imageFile: _imageFile,
              name: now,
              c: value[0].toInt(),
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonDivision(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('División'),
      onPressed: () {
        String now = DateTime.now().toString();
        pickImage(ImageSource.gallery).then(
          (value) {
            operDivi(
              imageFile2: value,
              imageFile1: _imageFile,
              name: now,
            ).then((value) => updateImage(now));
          },
        );
      },
    );
  }

  MaterialButton buttonBlending(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Blending'),
      onPressed: () {
        String now = DateTime.now().toString();
        pickImage(ImageSource.gallery).then(
          (value) {
            dialogBlending(context).then(
              (value2) => operBlending(
                imageFile2: value,
                imageFile1: _imageFile,
                x: value2[0],
                name: now,
              ).then(
                (value) => updateImage(now),
              ),
            );
          },
        );
      },
    );
  }

  MaterialButton buttonLogical(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text("Lógicos"),
      onPressed: () {
        String now = DateTime.now().toString();
        final act = CupertinoActionSheet(
          title: Text("Elija el operador lógico"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                pickImage(ImageSource.gallery).then(
                  (value) {
                    operLogical(
                      imageFile2: value,
                      imageFile1: _imageFile,
                      name: now,
                      cod: 0,
                    ).then((value) => updateImage(now));
                  },
                );
                Navigator.pop(context);
              },
              child: Text("AND"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                pickImage(ImageSource.gallery).then(
                  (value) {
                    operLogical(
                      imageFile2: value,
                      imageFile1: _imageFile,
                      name: now,
                      cod: 1,
                    ).then((value) => updateImage(now));
                  },
                );
                Navigator.pop(context);
              },
              child: Text("OR"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                pickImage(ImageSource.gallery).then(
                  (value) {
                    operLogical(
                      imageFile2: value,
                      imageFile1: _imageFile,
                      name: now,
                      cod: 2,
                    ).then((value) => updateImage(now));
                  },
                );
                Navigator.pop(context);
              },
              child: Text("XOR"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: Text("Cancelar")),
        );
        showCupertinoModalPopup(context: context, builder: (context) => act);
      },
    );
  }

  MaterialButton buttonCrop(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Crop image'),
      onPressed: () {
        setState(() {
          isCropImage = true;
        });
        //Navigator.push(
        //    context, MaterialPageRoute(builder: (context) => MyHomePage()));
      },
    );
  }
}
