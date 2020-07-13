import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grafica/algorithms/affine.dart';
import 'package:grafica/models/imageModel.dart';
import 'package:grafica/providers/imageProvider.dart';
import 'package:grafica/utils/points.dart';
import 'package:grafica/utils/pointsPaint.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File _imageFile;
  Uint8List img;
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

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    final directory = await getApplicationDocumentsDirectory();
    path = '${directory.path}/${DateTime.now().toString()}.jpeg';
    //_imageFile = await testCompressAndGetFile(selected, path);
    Imagen imgTemp = Imagen(selected);
    if (selected.lengthSync() > 1500000) {
      await imgTemp.compressFile();
    } else {
      imgTemp.uint8 = selected.readAsBytesSync();
    }
    Provider.of<ImagenProvider>(context, listen: false).addImage(imgTemp);

    setState(() {
      this.img =
          Provider.of<ImagenProvider>(context, listen: false).image.uint8;
      isCropImage = true;
    });
  }

  //TODO: Fix this, add provider
  Future<void> updateImage(Uint8List imgTemp) async {
    final directory = await getApplicationDocumentsDirectory();

    //_imageFile = File('${directory.path}/$name.jpg');
    Provider.of<ImagenProvider>(context, listen: false).image.uint8 = imgTemp;

    setState(() {
      this.img = imgTemp;
      isCropImage = false;
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
                    if (img != null) {
                      isCropImage = true;
                    }
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
          if (this.img != null && isCropImage == false) ...[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Image.memory(
                this.img,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
          if (this.img != null && isCropImage == true) ...[
            cropImage(),
          ],
          if (this.img == null) ...[
            Center(
              child: Text(
                "No hay imagen cargada",
                style: TextStyle(fontSize: 35),
              ),
            )
          ]
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
              //fit: StackFit.loose,
              children: <Widget>[
                // Hack to expand stack to fill all the space. There must be a better
                // way to do it.
                if (this.img != null) ...[
                  Image.memory(
                    this.img,
                    fit: BoxFit.fitWidth,
                  ),
                  CustomPaint(
                    painter: PaintPoints(points),
                  )
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget floatingCrop() {
    return FloatingActionButton(
      child: Icon(Icons.crop),
      onPressed: () {
        operCrop(
          image: this.img,
          points: points,
          withScreen: MediaQuery.of(context).size.width,
        ).then(
          (value) {
            updateImage(value);
            points = [
              Point(100, 100),
              Point(200, 100),
              Point(100, 200),
              Point(200, 200)
            ];
          },
        );
      },
    );
  }

  Widget floatingButton() {
    if (isCropImage) {
      return floatingCrop();
    }
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
