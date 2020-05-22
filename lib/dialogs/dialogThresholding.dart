import 'package:flutter/material.dart';
import 'package:grafica/forms/formThresholding.dart';

Future<List<double>> dialogThre(BuildContext context) {
  TextEditingController cController = TextEditingController();
  TextEditingController bController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateThre form = FormValidateThre(formKey, cController, bController);
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
              Text("0 si f[x, y] < umbral, caso contrario 1"),
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
