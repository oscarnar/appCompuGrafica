import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Division {
  img.Image imagen1;
  img.Image imagen2;
  Division(this.imagen1, this.imagen2);
}

Future<img.Image> operDiviCompute(Division data) async {
  data.imagen1 = img.grayscale(data.imagen1);
  data.imagen2 = img.grayscale(data.imagen2);
 
  int wi = data.imagen1.width;
  int he = data.imagen1.height;
  data.imagen2 = img.copyResize(data.imagen2,width: wi,height: he);

  for (int x = 0; x < wi; x++) {
    for (int y = 0; y < he; y++) {
      int red = img.getRed(data.imagen1[y * wi + x]);
      int red2 = img.getRed(data.imagen2[y * wi + x]);
      double newRed = (red/red2) * 20;
      if (newRed > 255) newRed = 255;
      data.imagen1.setPixelRgba(
        x,
        y,
        newRed.toInt(),
        newRed.toInt(),
        newRed.toInt(),
      );
    }
  }
  return data.imagen1;
}

Future<void> operDivi({File imageFile1, File imageFile2, String name}) async {
  img.Image ori = img.decodeImage(imageFile1.readAsBytesSync());
  img.Image image2 = img.decodeImage(imageFile2.readAsBytesSync());

  ori = await compute(operDiviCompute, Division(ori, image2));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
