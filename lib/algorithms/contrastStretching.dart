import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grafica/utils/histogramUtil.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ConstStret {
  img.Image imagen;
  List<PointHist> histogram;
  double porcentaje;

  ConstStret(this.imagen, this.histogram, this.porcentaje);
}

Future<img.Image> contrastStretCompute(ConstStret data) async {
  int totalPixel = data.imagen.width * data.imagen.height;
  int pixelError = ((totalPixel * data.porcentaje) ~/ 100).toInt();
  double sumaError = 0;
  int min, max;
  for (int i = 0; i < 256; i++) {
    sumaError += data.histogram[i].cant;
    if (sumaError >= pixelError) {
      min = i;
      break;
    }
  }
  sumaError = 0;
  for (int i = 255; i > 0; i--) {
    sumaError += data.histogram[i].cant;
    if (sumaError >= pixelError) {
      max = i;
      break;
    }
  }
  double constante = (255 / (max - min)) + 0;
  for (int x = 0; x < data.imagen.width; x++) {
    for (int y = 0; y < data.imagen.height; y++) {
      int red = img.getRed(data.imagen[y * data.imagen.width + x]);
      int temp = ((red - min) * constante).toInt();
      data.imagen.setPixelRgba(x, y, temp, temp, temp);
    }
  }
  return data.imagen;
}

Future<void> contrastStretching(
    {File imageFile,
    String name,
    List<PointHist> histogram,
    double porcentaje}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
  final directory = await getApplicationDocumentsDirectory();
  await compute(
          contrastStretCompute, ConstStret(ori, histogram, porcentaje))
      .then((value) {
    File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(value));
  });
}
