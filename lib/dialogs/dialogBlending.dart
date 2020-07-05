import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grafica/forms/formMulti.dart';

Future<List<double>> dialogBlending(BuildContext context) {
  TextEditingController cController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FormValidateMulti form = FormValidateMulti(formKey, cController, hintText: "Valor de X");
  return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: new Text("Oper. Blending"),
            content: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "NewImage = Image1*X + Image2*(1-X)"),
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
