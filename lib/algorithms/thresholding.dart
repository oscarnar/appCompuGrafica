import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<void> thresholding({int umbral, File imageFile, String name}) async {

    img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
    int wi = ori.width;
    int he = ori.height;
    for (int x = 0; x < wi; x++) {
      for (int y = 0; y < he; y++) {
        //if(ori[y*wi+x])
        //ori.setPixelRgba(x, y, );

        int red = img.getRed(ori[y * wi + x]);
        int newColor;
        if (red < umbral)
          newColor = 0;
        else
          newColor = 255;
        ori.setPixelRgba(x, y, newColor, newColor, newColor);
      }
    }
    //var now = DateTime.now().toString();
    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));

  }