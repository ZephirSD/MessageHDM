import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/BoutonAccueil.dart';
import 'package:messagehdm/Pages/Connexion.dart';
import 'package:messagehdm/Pages/Inscription.dart';
import 'package:messagehdm/Pages/SwitchPage.dart';
import 'package:session_next/session_next.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Composants/AuthProvider.dart';
import 'Composants/NotificationPush.dart';
import 'Composants/Fonctions/ThemeApplication.dart';
import 'Ressources/couleurs.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(), child: MyApp()));
}

var session = SessionNext();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        hintColor: CouleursPrefs.couleurPrinc,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        // primarySwatch: CouleursPrefs.couleurPrinc,
        hintColor: Colors.blueGrey[900],
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Message HDM',
        theme: theme,
        darkTheme: darkTheme,
        // home: session.get("tokenUser") == null ? MyHomePage() : SwitchPage(),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoggedIn) {
              return SwitchPage();
            } else {
              return MyHomePage();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool darkmode = false;
  void initState() {
    // TODO: implement initState
    NotificationsPushMessage.initialize(flutterLocalNotificationsPlugin, true);
    super.initState();
    setState(() {
      getCurrentTheme(darkmode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CouleursPrefs.couleurPrinc,
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
