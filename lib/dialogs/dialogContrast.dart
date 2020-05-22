import 'package:flutter/material.dart';
import 'package:grafica/forms/formConstrast.dart';

Future<List<double>> dialogContrast(BuildContext context) {
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateContrast form = FormValidateContrast(formKey, cController);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Contrast Stretching'),
        content: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("g[x,y] = (f[x,y] − c)(b − a)/(d − c) + a"),
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
