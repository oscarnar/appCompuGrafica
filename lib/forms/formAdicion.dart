import 'package:flutter/material.dart';

class FormValidateAdi extends StatefulWidget {
  final _formKey;
  final cController;

  FormValidateAdi(this._formKey, this.cController);
  @override
  _FormValidateStateExp createState() =>
      _FormValidateStateExp(_formKey, cController);
}

class _FormValidateStateExp extends State<FormValidateAdi> {
  final _formKey;
  final cController;

  _FormValidateStateExp(this._formKey, this.cController);
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
                labelText: 'C',
                hintText: 'Example 70',
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
