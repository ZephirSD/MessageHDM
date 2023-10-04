import 'package:flutter/material.dart';
import 'package:messagehdm/Pages/MessagePages.dart';
import 'package:messagehdm/Ressources/couleurs.dart';

class CaseEvent extends StatelessWidget {
  final String title;
  final String idEvent;
  final String admimEvent;
  final String modeEvent;
  CaseEvent(this.title, this.idEvent, this.modeEvent, {this.admimEvent = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      child: GestureDetector(
        onTap: () {
          print(title);
          session.set('event', idEvent);
          session.set('adminEvent', admimEvent);
          print(session.get('event'));
          print(session.get('adminEvent'));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MessagePage(title, idEvent, modeEvent)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CouleursPrefs.couleurGrisFonce,
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
