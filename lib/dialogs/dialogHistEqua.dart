import 'package:flutter/material.dart';

Future<List<double>> dialogHistEqua(BuildContext context) {
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  //FormValidateThre form = FormValidateThre(formKey, cController);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Histogram Equalization'),
        content: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Insertar formula de Exponencial"),
              //form,
            ],
          ),
        ),
      );
    },
  );
}
