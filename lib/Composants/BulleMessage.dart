import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BulleMessage extends StatelessWidget {
  final String message;
  final DateTime date;
  final String auteur;
  final String auteurSession;
  BulleMessage(this.message, this.date, this.auteur, this.auteurSession);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(auteur == auteurSession ? 100 : 0, 5,
                  auteur == auteurSession ? 0 : 100, 5),
              child: Container(
                decoration: BoxDecoration(
                  color: auteur == auteurSession
                      ? Colors.green[600]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: auteur == auteurSession
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: auteur == auteurSession
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: auteur == auteurSession
                  ? EdgeInsets.only(right: 10)
                  : EdgeInsets.only(right: 110),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    auteur == auteurSession ? "Vous" : auteur,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(date),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
