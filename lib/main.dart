import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/BoutonAccueil.dart';
import 'package:messagehdm/Pages/Connexion.dart';
import 'package:messagehdm/Pages/Inscription.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
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
            BoutonAccueil(ConnexionPage(), "Connexion"),
            BoutonAccueil(InscriptionPage(), "Inscription"),
          ],
        ),
      ),
    );
  }
}
