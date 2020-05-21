import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Log{
  img.Image imagen;
  int c;
  Log(this.imagen, this.c);
}

Future<img.Image> Logaritmo(Log data) async {
  int wi = data.imagen.width;
  int he = data.imagen.height;
  for (int x = 0; x < wi; x++) {
    for (int y = 0; y < he; y++) {
      int red = img.getRed(data.imagen[y * wi + x]);
      double newColor = data.c * (log(red) / ln10);
      if (newColor < 0) newColor = 0;
      if (newColor > 255) newColor = 255;
      data.imagen.setPixelRgba(
          x, y, newColor.toInt(), newColor.toInt(), newColor.toInt());
    }
  }
  return data.imagen;
}

Future<void> operLogaritmo({int c, File imageFile, String name}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());

  ori = await compute(Logaritmo, Log(ori,c));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
