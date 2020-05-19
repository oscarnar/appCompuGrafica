import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grafica/dialogs/dialogThresholding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    });
  }

  Future<void> updateImage(String name) async {
    final directory = await getApplicationDocumentsDirectory();

    setState(() {
      _imageFile = File('${directory.path}/$name.jpg');
    });
  }

  updateHistogram() {
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
      setState(() {
      });
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
          content: Flexible(child: chart(histogram)),
        );
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
            icon: Icon(Icons.assessment),
            onPressed: () {
              dialogHistogram(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              buttonExp(context),
              buttonLog(context),
              buttonRaiz(context),
              buttonThresholding(context),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            chart(histogram),
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
            );
            updateImage(now);
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
            );
            updateImage(now);
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
            );
            updateImage(now);
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
            );
            updateImage(now);
          },
        );
      },
    );
  }
}

Widget chart(List<PointHist> data) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    crosshairBehavior: CrosshairBehavior(
      enable: true,
      lineColor: Colors.red,
      lineDashArray: <double>[5, 5],
      lineWidth: 2,
      lineType: CrosshairLineType.vertical,
    ),
    title: ChartTitle(text: "Histograma"),
    legend: Legend(isVisible: true),
    series: <ChartSeries>[
      LineSeries<PointHist, int>(
        dataSource: data,
        xValueMapper: (PointHist dat, _) => dat.pixel,
        yValueMapper: (PointHist dat, _) => dat.cant,
      )
    ],
    trackballBehavior: TrackballBehavior(
      enable: true,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: Colors.red,
      ),
    ),
  );
}

class PointHist {
  int cant;
  int pixel;
  PointHist(this.pixel, this.cant);
}
