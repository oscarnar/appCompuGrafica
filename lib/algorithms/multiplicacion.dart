import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Multiplicacion {
  img.Image imagen;
  int c;
  Multiplicacion(this.imagen, this.c);
}

Future<img.Image> operMultiCompute(Multiplicacion data) async {
  int wi = data.imagen.width;
  int he = data.imagen.height;

  for (int x = 0; x < wi; x++) {
    for (int y = 0; y < he; y++) {
      int red = img.getRed(data.imagen[y * wi + x]);
      int green = img.getGreen(data.imagen[y * wi + x]);
      int blue = img.getBlue(data.imagen[y * wi + x]);
      int newRed = red * data.c;
      int newGreen = green * data.c;
      int newBlue = blue * data.c;
      if (newRed > 255) newRed = 255;
      if (newGreen > 255) newGreen = 255;
      if (newBlue > 255) newBlue = 255;
      data.imagen.setPixelRgba(
        x,
        y,
        newRed,
        newGreen,
        newBlue,
      );
    }
  }
  return data.imagen;
}

Future<void> operMulti({File imageFile, int c, String name}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());

  ori = await compute(operMultiCompute, Multiplicacion(ori, c));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
