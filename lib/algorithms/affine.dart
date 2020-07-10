import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:grafica/utils/points.dart';
import 'package:image/image.dart' as img;
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:ml_linalg/matrix.dart';
//import 'package:vector_math/vector_math.dart';
import 'package:scidart/numdart.dart';

class Affine {
  img.Image imagen;
  Array2d A;
  Array2d B;
  Affine(this.imagen, this.A, this.B);
}
//TODO: el translate copia lo negro, hacer el fondo negro
Future<img.Image> operAffineComp(Affine data) async {
  //data.imagen.
  img.Image img_output = data.imagen.clone();
  int withImage = data.imagen.width;
  int heigthImage = data.imagen.height;
  print("$withImage $heigthImage");
  Array2d invA = matrixInverse(data.A);
  print(invA);
  for(int x=0; x < withImage; x++){
    for(int y=0; y < heigthImage; y++){
      Array tempX = Array([x.toDouble()]);
      Array tempY = Array([y.toDouble()]);
      Array2d Y = Array2d([tempX,tempY]) - data.B;
      
      Array2d temp = matrixDot(invA, Y);
      
      int axisX = temp[0][0].toInt();
      int axisY = temp[1][0].toInt();
      if(axisX < withImage && axisY < heigthImage && axisX >= 0 && axisY >= 0){
        img_output[y*withImage + x] = data.imagen[axisY * withImage + axisX];
      }
    }
  }
  return img_output;
}

Array2d matrixZeros(int fil,int col){
  Array2d matrix = Array2d.empty();
  for(int i=0; i<fil; i++){
    matrix.add(zeros(col));
  }
  return matrix;
}

Array2d getAffine(List<Point> src,List<Point> dst){
  Array2d A = matrixZeros(6, 6);
  Array2d B = matrixZeros(6, 1);
  Array2d M = matrixZeros(2, 3);

  for(int i=0; i<3; i++){
    A[i][0] = A[i+3][3] = src[i].px;
    A[i][1] = A[i+3][4] = src[i].py;

    A[i][2] = A[i+3][5] = 1;
    B[i][0] = dst[i].px;
    B[i+3][0] = dst[i].py;
  }
  Array2d invA = matrixInverse(A);
  Array2d X = matrixDot(invA, B);
  int a = 0;
  for(int i=0; i<2; i++){
    for(int j=0; j<3; j++){
      M[i][j] = X[a][0];
      a++;
    }
  }
  return M;
}

Array2d getA(Array2d M){
  Array2d A = matrixZeros(2, 2);
  for(int i = 0; i<2; i++){
    for(int j=0; j<2; j++){
      A[i][j] = M[i][j];
    }
  }
  return A;
}

Array2d getB(Array2d M){
  Array2d B = matrixZeros(2, 1);
  B[0][0] = M[0][2];
  B[1][0] = M[1][2];
  return B;
}

List<Point> realPoints(List<Point> points, double screen, int widthImage){
  for(int i=0; i<points.length; i++){
    double realPointX = (points[i].px * widthImage) / screen;
    double realPointY = (realPointX * points[i].py) / points[i].px;
    points[i].px = realPointX;
    points[i].py = realPointY;
  }
  return points;
}

double distance(Point a, Point b){
  double x = (a.px - b.px).abs();
  double y = (a.py - b.py).abs();
  double distance =  pow(x,2) + pow(y,2);
  distance = sqrt(distance);
  return distance;
}
// TODO: corregir filtros, si es una imagen grande la esta girando
// Poner botones de filtros
Future<void> operCrop(
    {File imageFile, String name,List<Point> points, double withScreen}) async {
  print("inicio "+DateTime.now().toString());
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());
  print("fin "+DateTime.now().toString());
  double distWidth = distance(points[0], points[1]);
  double distHeigth = distance(points[0], points[2]);
  double newWidth;
  double newHeigth;
  if(distWidth > distHeigth){
    newWidth = ori.width.toDouble();
    newHeigth = ((distHeigth * newWidth) / distWidth);
    //if(newHeigth > ori.width)
    //  newHeigth = ori.height.toDouble();
  }
  else{
    newHeigth = ori.height.toDouble();
    newWidth = ((distWidth * newHeigth) / distHeigth);
    //if(newWidth > ori.width)
    //  newWidth = ori.width.toDouble();
  }
  final widthImg = ori.width;
  points = realPoints(points, withScreen, widthImg);
  Point p2 = Point(newWidth ,0);
  Point p3 = Point(0,newHeigth);

  Array2d M = getAffine([points[0],points[1],points[2]],[Point(0,0),p2,p3]);
  Array2d AM = getA(M);
  Array2d BM = getB(M);

  ori = await compute(operAffineComp,Affine(ori, AM, BM));

  ori = img.copyCrop(ori,0,0,newWidth.toInt()-1,newHeigth.toInt()-1);
  ori = img.grayscale(ori);

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name+"prueba".jpg').writeAsBytesSync(img.encodeJpg(ori));

  File imagen = File('${directory.path}/$name+"prueba".jpg');

  //dynamic ima = await ImgProc.adaptiveThreshold(imagen.readAsBytesSync(), 125, ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 11, 12);
  dynamic ima = await ImgProc.adaptiveThreshold(imagen.readAsBytesSync(), 255, ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 7, 14);
  //ima = await ImgProc.threshold(ima, 120, 255, ImgProc.threshBinary);
  ima = await ImgProc.bilateralFilter(ima, 10, 5, 10, Core.borderConstant);
  //ima = await ImgProc.dilate(ima, [1, 1]);
  //ima = await ImgProc.erode(ima, [1, 1]);
  
  File('${directory.path}/$name+"prueba1".jpg').writeAsBytesSync(ima);
  imagen = File('${directory.path}/$name+"prueba1".jpg');
  ori = img.decodeImage(imagen.readAsBytesSync());
  ori = img.smooth(ori,15 );
  //ori = img.emboss(ori);
  //ori = img.invert(ori);

  //File('${directory.path}/$name.jpg').writeAsBytesSync(ori.data);
  print("inicio write "+DateTime.now().toString());
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
  print("fin write"+DateTime.now().toString());
}

Future<void> operAffine(
    {File imageFile, List<List<double>> matrixM, String name,List<Point> points}) async {
  img.Image ori = img.decodeImage(imageFile.readAsBytesSync());

  var A = Array2d([
    Array([matrixM[0][0],
        matrixM[0][1],]
    ),
    Array([
        matrixM[1][0],
        matrixM[1][1],
      ]),
  ]);
  var B = Array2d([
    Array([matrixM[0][2]]),
    Array([matrixM[1][2]]),
  ],);

  Array2d M = getAffine([Point(2,1),Point(2,3),Point(4,5)],[Point(3,1),Point(2,3),Point(6,5)]);
  Array2d AM = getA(M);
  Array2d BM = getB(M);

  ori = await compute(operAffineComp,Affine(ori, AM, BM));

  final directory = await getApplicationDocumentsDirectory();
  File('${directory.path}/$name.jpg').writeAsBytesSync(img.encodeJpg(ori));
}
