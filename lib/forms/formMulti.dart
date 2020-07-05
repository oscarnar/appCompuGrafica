import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FormValidateMulti extends StatefulWidget {
  final _formKey;
  final cController;
  String hintText;

  FormValidateMulti(this._formKey, this.cController, {this.hintText="Constante por ejemplo 4"});
  @override
  _FormValidateStateExp createState() =>
      _FormValidateStateExp(_formKey, cController, hintText);
}

class _FormValidateStateExp extends State<FormValidateMulti> {
  final _formKey;
  final cController;
  String hintText;

  _FormValidateStateExp(this._formKey, this.cController, this.hintText);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            CupertinoTextField(
              controller: cController,
              prefix: Icon(CupertinoIcons.pen),
              keyboardType: TextInputType.number,
              placeholder: hintText,
              decoration: BoxDecoration(color: Colors.white10),
            ),
          ],
        ),
      ),
    );
  }
}
