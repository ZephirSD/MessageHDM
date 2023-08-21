import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String textInput;
  final Icon? iconInput;
  final TextEditingController? _controller;
  final bool hiddenPassword;
  final String? valeurDefaut;
  final TextInputType txtInput;
  InputForm(this.textInput, this._controller,
      {this.iconInput = null,
      this.hiddenPassword = false,
      this.valeurDefaut = null,
      this.txtInput = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 2)),
      child: TextField(
        controller: _controller,
        obscureText: hiddenPassword,
        keyboardType: txtInput,
        decoration: InputDecoration(
          labelText: textInput,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          border: InputBorder.none,
          focusColor: Colors.white,
          fillColor: Colors.white,
          icon: iconInput,
          iconColor: Colors.white,
        ),
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

class InputModifForm extends StatelessWidget {
  final String textInput;
  final TextEditingController _controller;
  final bool modePassword;
  InputModifForm(this.textInput, this._controller, {this.modePassword = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 2)),
      child: TextField(
        controller: _controller,
        obscureText: modePassword,
        decoration: InputDecoration(
          labelText: textInput,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          border: InputBorder.none,
          focusColor: Colors.white,
          fillColor: Colors.white,
          iconColor: Colors.white,
        ),
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
