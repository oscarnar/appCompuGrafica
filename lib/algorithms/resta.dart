import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Resta{
  img.Image imagen1;
  img.Image imagen2;
  Resta(this.imagen1, this.imagen2);
}

Future<img.Image> operRestaCompute(Resta data) async {
  int wi1 = data.imagen1.width;
  int he1 = data.imagen1.height;
  int wi2 = data.imagen2.width;
  int he2 = data.imagen2.height;
  int wi = wi1,he = he1;
  if(wi1 > wi2) wi = wi2;
  if(he1 > he2) he = he2;

  for (int x = 0; x < wi; x++) {
    for (int y = 0; y < he; y++) {
      int red1 = img.getRed(data.imagen1[y * wi + x]);
      int red2 = img.getRed(data.imagen2[y * wi + x]);
      int newColor = (red1 - red2).abs();
      if (newColor < 0) newColor = 0;
      if (newColor > 255) newColor = 255;
      data.imagen1.setPixelRgba(
          x, y, newColor, newColor, newColor);
    }
  }
  return data.imagen1;
}

Future<void> operResta({File imageFile,File imageFile2, String name}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
  img.Image newImg = img.decodeImage(imageFile2.readAsBytesSync());

  ori = await compute(operRestaCompute, Resta(ori,newImg));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
