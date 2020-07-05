import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grafica/utils/binary.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Logical{
  img.Image imagen1;
  img.Image imagen2;
  int cod;
  Logical(this.imagen1, this.imagen2, this.cod);
}

Future<img.Image> operLogicalCompute(Logical data) async {
  data.imagen1 = img.grayscale(data.imagen1);
  data.imagen2 = img.grayscale(data.imagen2);

  int wi = data.imagen1.width;
  int he = data.imagen1.height;
  data.imagen2 = img.copyResize(data.imagen2,width: wi,height: he);

  for (int x = 0; x < wi; x++) {
    for (int y = 0; y < he; y++) {
      int red = img.getRed(data.imagen1[y * wi + x]);
      int red2 = img.getRed(data.imagen2[y * wi + x]);
      List<bool> bin1 = decToBin(red);
      List<bool> bin2 = decToBin(red2);
      int newRed = 0;
      if(data.cod == 0)
      newRed = myAnd(bin1,bin2);
      if(data.cod == 1)
      newRed = myOr(bin1,bin2);
      if(data.cod == 2)
      newRed = myXor(bin1,bin2);
      
      if (newRed > 255) newRed = 255;
      data.imagen1.setPixelRgba(
        x,
        y,
        newRed,
        newRed,
        newRed,
      );
    }
  }
  return data.imagen1;
}

Future<void> operLogical({File imageFile1, File imageFile2, int cod, String name}) async {
  img.Image ori = img.decodeImage(imageFile1.readAsBytesSync());
  img.Image image2 = img.decodeImage(imageFile2.readAsBytesSync());
  // cod 0 AND, 1 OR, 2 XOR
  ori = await compute(operLogicalCompute, Logical(ori, image2, cod));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
