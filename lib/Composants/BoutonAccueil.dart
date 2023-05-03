import 'package:flutter/material.dart';

class BoutonAccueil extends StatelessWidget {
  Widget page;
  String titreBouton;
  BoutonAccueil(this.page, this.titreBouton);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 65),
        margin: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.blueGrey[600],
        child: Text(
          titreBouton,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
