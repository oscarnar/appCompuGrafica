import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<void> operExponencial({double c,double b, File imageFile, String name}) async {

    img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
    int wi = ori.width;
    int he = ori.height;

    for (int x = 0; x < wi; x++) {
      for (int y = 0; y < he; y++) {
        int red = img.getRed(ori[y * wi + x]);
        double newColor = c * (pow(b,red));
        if (newColor < 0)
          newColor = 0;
        if(newColor > 255)
          newColor = 255;
        ori.setPixelRgba(x, y, newColor.toInt(), newColor.toInt(), newColor.toInt());
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
  }