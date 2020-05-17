import 'package:flutter/material.dart';
import 'package:grafica/forms/formExponecial.dart';

Future<List<double>> dialogExp(BuildContext context) {
  TextEditingController bController = TextEditingController();
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateExp form = FormValidateExp(formKey, cController, bController);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Oper. Exponecial'),
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
                  double.parse(bController.text),
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
