import 'package:flutter/material.dart';

class FormValidateContrast extends StatefulWidget {
  final _formKey;
  final cController;

  FormValidateContrast(this._formKey, this.cController);
  @override
  _FormValidateStateConstrast createState() =>
      _FormValidateStateConstrast(_formKey, cController);
}

class _FormValidateStateConstrast extends State<FormValidateContrast> {
  final _formKey;
  final cController;

  _FormValidateStateConstrast(this._formKey, this.cController);
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
                  return 'Tiene que ingresar un valor';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Porcentaje',
                hintText: 'Example 8.5',
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
          ],
        ),
      ),
    );
  }
}
