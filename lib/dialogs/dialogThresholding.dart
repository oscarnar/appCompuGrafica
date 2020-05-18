import 'package:flutter/material.dart';
import 'package:grafica/forms/formThresholding.dart';

Future<List<double>> dialogThre(BuildContext context) {
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateThre form = FormValidateThre(formKey, cController);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Thresholding'),
        content: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Insertar formula de Exponencial"),
              form,
            ],
          ),
        ),
        actions: [
          MaterialButton(
            elevation: 5,
            child: Text('OK'),
            onPressed: () {
              if (formKey.currentState.validate()) {
                List<double> list = [
                  double.parse(cController.text),
                ];
                Navigator.of(context).pop(list);
              }
            },
          )
        ],
      );
    },
  );
}
