import 'package:flutter/material.dart';

class FormValidateExp extends StatefulWidget {
  final _formKey;
  final cController;
  final bController;

  FormValidateExp(this._formKey, this.cController, this.bController);
  @override
  _FormValidateStateExp createState() =>
      _FormValidateStateExp(_formKey, cController, bController);
}

class _FormValidateStateExp extends State<FormValidateExp> {
  final _formKey;
  final cController;
  final bController;

  _FormValidateStateExp(this._formKey, this.cController, this.bController);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: cController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Ingrese un valor";
                }
                double temp = double.parse(value);
                if (temp > 255 || temp < 0) {
                  return 'Tiene que ingresar un valor entre 0 y 255';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'C',
                hintText: 'Example 20',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400], width: 2.5),
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.assessment),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFormField(
              controller: bController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Ingrese un valor";
                }
                double temp = double.parse(value);
                if (temp > 255 || temp < 0) {
                  return 'Tiene que ingresar un valor entre 0 y 255';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'B',
                hintText: 'Example 1.5',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400], width: 2.5),
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.assessment),
                fillColor: Colors.white,
                filled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
