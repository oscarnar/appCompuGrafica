import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<void> raiceToPower({int c,int r, File imageFile, String name}) async {

    img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
    int wi = ori.width;
    int he = ori.height;

    for (int x = 0; x < wi; x++) {
      for (int y = 0; y < he; y++) {
        int red = img.getRed(ori[y * wi + x]);
        int newColor = c * (pow(red,r));
        if (newColor < 0)
          newColor = 0;
        if(newColor > 255)
          newColor = 255;
        ori.setPixelRgba(x, y, newColor, newColor, newColor);
      }
    }
    
    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
  }