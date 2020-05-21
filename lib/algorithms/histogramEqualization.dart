import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grafica/utils/histogramUtil.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class HistoEqua {
  img.Image imagen;
  List<PointHist> histogram;
  int width;
  int heigth;

  HistoEqua(this.imagen, this.histogram, this.width, this.heigth);
}

Future<img.Image> histogramEquaCompute(HistoEqua data) async {
  int totalPixel = data.heigth * data.width;
  List<int> sn = List(256);
  double suma = 0;
  for (int i = 0; i < 256; i++) {
    suma = suma + (data.histogram[i].cant / totalPixel);
    sn[i] = (255*suma).toInt();
  }
  print(sn[10]);
  for (int x = 0; x < data.width; x++) {
    for (int y = 0; y < data.heigth; y++) {
      int red = img.getRed(data.imagen[y * data.width + x]);
      data.imagen.setPixelRgba(x, y, sn[red], sn[red], sn[red]);
    }
  }
  return data.imagen;
}

Future<void> histogramEqualization(
    {File imageFile, String name, List<PointHist> histogram}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
  int wi = ori.width;
  int he = ori.height;
  print("llamo compute");

  ori = await compute(histogramEquaCompute, HistoEqua(ori, histogram, wi, he));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
