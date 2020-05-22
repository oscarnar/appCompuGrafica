import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<void> thresholding(
    {List<double> umbral, File imageFile, String name}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
  int wi = ori.width;
  int he = ori.height;
  if (umbral.length == 1) {
    for (int x = 0; x < wi; x++) {
      for (int y = 0; y < he; y++) {
        int red = img.getRed(ori[y * wi + x]);
        int newColor;
        if (red < umbral[0])
          newColor = 0;
        else
          newColor = 255;
        ori.setPixelRgba(x, y, newColor, newColor, newColor);
      }
    }
  }
  else{
    int min, max;
    if(umbral[0] > umbral[1]){
      min = umbral[1].toInt();
      max = umbral[0].toInt();
    }
    else{
      min = umbral[0].toInt();
      max = umbral[1].toInt();
    }
    for (int x = 0; x < wi; x++) {
      for (int y = 0; y < he; y++) {
        int red = img.getRed(ori[y * wi + x]);
        int newColor;
        if (red < min || red > max)
          newColor = 0;
        else
          newColor = 255;
        ori.setPixelRgba(x, y, newColor, newColor, newColor);
      }
    }
  }
  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
