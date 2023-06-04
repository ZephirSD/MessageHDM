import 'package:flutter/material.dart';

class CaseEvent extends StatelessWidget {
  final String title;
  // final int index;
  CaseEvent(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      child: GestureDetector(
        onTap: () {
          print(title);
        },
        child: Container(
          height: 150,
          color: Colors.deepPurple[400],
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
