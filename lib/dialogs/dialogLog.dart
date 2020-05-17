import 'package:flutter/material.dart';
import 'package:grafica/forms/formLogaritmo.dart';

Future<List<double>> dialogLog(BuildContext context) {
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateLog form = FormValidateLog(formKey, cController);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Oper. Logaritmo'),
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
