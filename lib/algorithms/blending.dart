import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Blending{
  img.Image imagen1;
  img.Image imagen2;
  double x;
  Blending(this.imagen1, this.imagen2, this.x);
}

Future<img.Image> operBlendingCompute(Blending data) async { 
  int wi = data.imagen1.width;
  int he = data.imagen1.height;
  data.imagen2 = img.copyResize(data.imagen2,width: wi,height: he);

  for (int x = 0; x < wi; x++) {
    for (int y = 0; y < he; y++) {
      int red = img.getRed(data.imagen1[y * wi + x]);
      int green = img.getGreen(data.imagen1[y * wi + x]);
      int blue = img.getBlue(data.imagen1[y * wi + x]);
      int red2 = img.getRed(data.imagen2[y * wi + x]);
      int green2 = img.getGreen(data.imagen2[y * wi + x]);
      int blue2 = img.getBlue(data.imagen2[y * wi + x]);
      double newRed = (red*data.x) + (red2*(1-data.x));
      double newGreen = (green*data.x) + (green2*(1-data.x));
      double newBlue = (blue*data.x) + (blue2*(1-data.x));
      if (newRed > 255) newRed = 255;
      if (newGreen > 255) newGreen = 255;
      if (newBlue > 255) newBlue = 255;
      data.imagen1.setPixelRgba(
        x,
        y,
        newRed.toInt(),
        newGreen.toInt(),
        newBlue.toInt(),
      );
    }
  }
  return data.imagen1;
}

Future<void> operBlending({File imageFile1, File imageFile2, double x, String name}) async {
  img.Image ori = img.decodeImage(imageFile1.readAsBytesSync());
  img.Image image2 = img.decodeImage(imageFile2.readAsBytesSync());

  ori = await compute(operBlendingCompute, Blending(ori, image2, x));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
