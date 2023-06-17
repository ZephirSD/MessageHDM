import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/ChangePage.dart';
// import 'package:messagehdm/Composants/NavHomeBottom.dart';
import 'package:messagehdm/Pages/DocumentPage.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
import 'package:session_next/session_next.dart';

import '../main.dart';

class SwitchPage extends StatefulWidget {
  SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  int _selectedIndex = 0;
  var session = SessionNext();

  logoutFunction() {
    session.removeAll();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => MyApp(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: new Stack(
          children: <Widget>[
            ChangePage(EventPageAccueil(), 0, _selectedIndex),
            ChangePage(DocumentPage(), 1, _selectedIndex),
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
                icon: Icon(Icons.settings_applications),
                label: 'Paramêtres',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Comptes',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueGrey,
            unselectedItemColor: Colors.black,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            }),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          shadowColor: Colors.transparent,
          actions: [
            ElevatedButton(
              onPressed: () {
                logoutFunction();
              },
              child: Icon(Icons.logout),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
            )
          ],
        ),
      ),
    );
  }
}
