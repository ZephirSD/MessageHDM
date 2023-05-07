import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String textInput;
  final Icon iconInput;
  final TextEditingController _controller;
  final bool hiddenPassword;
  InputForm(this.textInput, this.iconInput, this._controller,
      {this.hiddenPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: hiddenPassword,
      decoration: InputDecoration(
        labelText: textInput,
        icon: iconInput,
      ),
    );
  }
}
