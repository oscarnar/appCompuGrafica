import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grafica/forms/formMulti.dart';

Future<List<double>> dialogMulti(BuildContext context) {
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateMulti form = FormValidateMulti(formKey, cController);
  return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: new Text("Oper. Multiplicación"),
            content: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Se multiplica a cada pixel de la imagen por una constante."),
                  form,
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    List<double> list = [
                      double.parse(cController.text),
                    ];
                    Navigator.of(context).pop(list);
                  }
                },
                child: Text('OK'),
              ),
            ],
          ));
}
