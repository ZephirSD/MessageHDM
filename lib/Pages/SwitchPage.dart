import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/ChangePage.dart';
import 'package:messagehdm/Composants/Fonctions/FunctDeconnexion.dart';
import 'package:messagehdm/Pages/ComptePage.dart';
import 'package:messagehdm/Pages/DocumentPage.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
import 'package:messagehdm/Pages/NotificationsPages.dart';
import 'package:session_next/session_next.dart';

import '../Ressources/couleurs.dart';

class SwitchPage extends StatefulWidget {
  SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  int _selectedIndex = 0;
  var session = SessionNext();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: new Stack(
          children: <Widget>[
            ChangePage(EventPageAccueil(), 0, _selectedIndex),
            ChangePage(DocumentPage(), 1, _selectedIndex),
            ChangePage(NotificationPages(), 2, _selectedIndex),
            ChangePage(ComptePage(), 3, _selectedIndex),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_special_rounded),
                label: 'Documents',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Comptes',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: CouleursPrefs.couleurPrinc,
            unselectedItemColor: Colors.black,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            }),
        appBar: AppBar(
          backgroundColor: CouleursPrefs.couleurPrinc,
          shadowColor: Colors.transparent,
          actions: [
            ElevatedButton(
              onPressed: () {
                functDeconnexion(context);
              },
              child: Icon(Icons.logout),
              style: ElevatedButton.styleFrom(
                  backgroundColor: CouleursPrefs.couleurRose),
            )
          ],
        ),
      ),
    );
  }
}
