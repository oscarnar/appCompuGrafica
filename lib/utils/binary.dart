import 'dart:math';

List<bool> decToBin(int decimal_value){
  List<bool> binary = [];
  for(int i=0; i<8; i++){
    //binary.insert(0,decimal_value % 2);
    //binary.add(decimal_value % 2);
    if(decimal_value % 2 == 1)
    binary.add(true);
    else  binary.add(false);
    decimal_value = (decimal_value/2).floor();
  }
  return binary;
}

int binToDec(List<bool> binary){
  int decimal_value = 0;
  for(int i=0; i<binary.length; i++){
    if(binary[i] == true){
      decimal_value += pow(2,i);
    }
  }
  return decimal_value;
}

int myAnd(List<bool> x,List<bool> y){
  int result = 0;  
  for(int i=0; i<x.length; i++){
    if(x[i] == true && y[i]==true){
      result += pow(2,i);
    }
  }
  return result;
}

int myOr(List<bool> x,List<bool> y){
  int result = 0;
  for(int i=0; i<x.length; i++){
    if(x[i] == true || y[i]==true){
      result += pow(2,i);
    }
  }
  return result;
}

int myXor(List<bool> x,List<bool> y){
  int result = 0; 
  for(int i=0; i<x.length; i++){
    if(x[i] != y[i]){
      result += pow(2,i);
    }
  }
  return result;
}