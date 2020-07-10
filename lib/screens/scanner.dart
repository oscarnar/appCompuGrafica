import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grafica/algorithms/affine.dart';
import 'package:grafica/utils/points.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:opencv/opencv.dart';

class Proba extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("holis"),
      ),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File _imageFile;
  String path;
  bool isCropImage = false;
  List<List<double>> matrixPrueba = [
    [2, 0, 0],
    [0, 2, 0]
  ];
  //Image proba;
  double fixPos = 23;
  List<Point> points = [
    Point(0, 0),
    Point(200, 100),
    Point(100, 200),
    Point(200, 200)
  ];
  Icon iconCrop = Icon(
    Icons.arrow_drop_down_circle,
    color: Colors.red[400],
  );

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 88,
      );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    final directory = await getApplicationDocumentsDirectory();
    path = '${directory.path}/${DateTime.now().toString()}.jpeg';
    _imageFile = await testCompressAndGetFile(selected, path);
    
    //proba = Image.file(_imageFile);

    setState(() {
      isCropImage = true;
    });
  }

  Future<void> updateImage(String name) async {
    final directory = await getApplicationDocumentsDirectory();

    _imageFile = File('${directory.path}/$name.jpg');

    setState(() {
      isCropImage = false;
      _imageFile = File('${directory.path}/$name.jpg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CamScanner UNSA"),
        centerTitle: true,
      ),
      floatingActionButton: floatingButton(),
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              MaterialButton(
                child: Text("CropImage"),
                onPressed: () {
                  setState(() {
                    isCropImage = true;
                  });
                },
              )
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          //if (_imageFile != null) ...[
          //  Image.file(_imageFile),
          //]
          if (_imageFile != null && isCropImage == false) ...[
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Image.file(
                  _imageFile,
                  fit: BoxFit.fitWidth,
                )),
          ],
          if (_imageFile != null && isCropImage == true) ...[
            cropImage(),
          ],
        ],
      ),
    );
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    //print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset =
        box.globalToLocal(details.localPosition); // .globalPosition);
    Point actual = Point(localOffset.dx, localOffset.dy);
    int bestPoint = close(actual, points);
    //print('${actual.px} ${actual.py}');
    setState(() {
      points[bestPoint].px = actual.px;
      points[bestPoint].py = actual.py;
    });
  }

  void onDragStart(BuildContext context, DragStartDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.localPosition);
    Point actual = Point(localOffset.dx, localOffset.dy);
    int bestPoint = close(actual, points);
    setState(() {
      points[bestPoint].px = actual.px;
      points[bestPoint].py = actual.py;
    });
  }

  void onDrag(BuildContext context, DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.localPosition);
    Point actual = Point(localOffset.dx, localOffset.dy);
    int bestPoint = close(actual, points);
    setState(() {
      points[bestPoint].px = actual.px;
      points[bestPoint].py = actual.py;
    });
  }

  Widget cropImageStack() {
    return Stack(
      children: [
        Image.file(_imageFile),
      ],
    );
  }
  
  //Future<dynamic> probaFun() async {
  //  //dynamic img = await _imageFile.readAsBytes();
  //  dynamic border = ImgProc.copyMakeBorder(await _imageFile.readAsBytes(), 20, 20, 20, 20, Core.borderConstant);
  //  setState(() {
  //    proba = Image.memory(border);
  //  });
  //  return border;
  //}
  Widget cropImage() {
    //dynamic border = probaFun();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: new GestureDetector(
            onTapDown: (TapDownDetails details) => onTapDown(context, details),
            onPanStart: (DragStartDetails details) =>
                onDragStart(context, details),
            onPanUpdate: (DragUpdateDetails details) =>
                onDrag(context, details),
            child: new Stack(
              //fit: StackFit.expand,
              children: <Widget>[
                // Hack to expand stack to fill all the space. There must be a better
                // way to do it.
                Image.file(
                  _imageFile,
                  fit: BoxFit.fitWidth,
                ),
                posPoints(fixPos, points[0]),
                posPoints(fixPos, points[1]),
                posPoints(fixPos, points[2]),
                posPoints(fixPos, points[3])
              ],
            ),
          ),
        ),
        RaisedButton(
          child: Text("Recortar Crop Image"),
          onPressed: () {
            String now = DateTime.now().toString();
            operCrop(
              imageFile: _imageFile,
              name: now,
              points: points,
              withScreen: MediaQuery.of(context).size.width,
            ).then((value) {
              updateImage(now);
              points = [
                Point(100, 100),
                Point(200, 100),
                Point(100, 200),
                Point(200, 200)
              ];
            });
          },
        )
      ],
    );
  }

  Widget floatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "floating2",
          mini: true,
          child: Icon(Icons.camera_alt),
          onPressed: () {
            _pickImage(ImageSource.camera);
          },
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          heroTag: "floating3",
          child: Icon(Icons.image),
          onPressed: () {
            _pickImage(ImageSource.gallery);
          },
        ),
      ],
    );
  }

  Widget posPoints(double fixPos, Point point) {
    return Positioned(
      child: IconButton(
        icon: iconCrop,
        onPressed: () {},
      ),
      left: point.px - fixPos,
      top: point.py - fixPos,
    );
  }
}
