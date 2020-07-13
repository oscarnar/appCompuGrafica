import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class Imagen{
  Uint8List uint8;
  File imageFile;
  String path;

  Imagen(this.imageFile){
    this.path = imageFile.path;
    //this.uint8 = imageFile.readAsBytesSync();
    //compressFile();
  }

  void update(){
    File(this.path).writeAsBytesSync(uint8);
    imageFile = File(path);
  }

  Future<void> compressFile() async {
    var result = await FlutterImageCompress.compressWithFile(
      this.path,
      minWidth: 1920,
      minHeight: 1080,
      quality: 94,
    );
    this.uint8 = result;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 88,
      );

    return result;
  }
}