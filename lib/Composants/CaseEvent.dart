import 'package:flutter/material.dart';
import 'package:messagehdm/Pages/MessagePages.dart';

class CaseEvent extends StatelessWidget {
  final String title;
  final String idEvent;
  CaseEvent(this.title, this.idEvent);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      child: GestureDetector(
        onTap: () {
          print(title);
          session.set('event', idEvent);
          print(session.get('event'));
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessagePage(title)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepPurple[400],
          ),
          height: 150,
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
