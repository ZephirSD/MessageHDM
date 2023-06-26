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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 2)),
      child: TextFormField(
        controller: _controller,
        obscureText: hiddenPassword,
        decoration: InputDecoration(
          labelText: textInput,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          border: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Colors.grey.shade300,
          //     width: 2,
          //   ),
          //   borderRadius: BorderRadius.circular(25),
          // ),
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
