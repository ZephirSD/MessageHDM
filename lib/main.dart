import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/BoutonAccueil.dart';
import 'package:messagehdm/Pages/Connexion.dart';
import 'package:messagehdm/Pages/Inscription.dart';
import 'package:messagehdm/Pages/SwitchPage.dart';
import 'package:session_next/session_next.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var session = SessionNext();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message HDM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: session.get("tokenUser") == null ? MyHomePage() : SwitchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoutonAccueil(const ConnexionPage(), "Connexion"),
            BoutonAccueil(const InscriptionPage(), "Inscription"),
          ],
        ),
      ),
    );
  }
}
