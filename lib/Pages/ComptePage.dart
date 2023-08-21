import 'package:flutter/material.dart';
import 'package:messagehdm/Pages/ModifPasswordPage.dart';
import 'package:messagehdm/Pages/ModifProfilPage.dart';
import 'package:session_next/session_next.dart';
import '../Composants/CaseCompte.dart';
import '../Ressources/couleurs.dart';

class ComptePage extends StatelessWidget {
  const ComptePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CompteContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

var session = SessionNext();

class CompteContainer extends StatefulWidget {
  const CompteContainer({super.key});

  @override
  State<CompteContainer> createState() => _CompteContainerState();
}

class _CompteContainerState extends State<CompteContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CouleursPrefs.couleurPrinc,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: CouleursPrefs.couleurPrinc,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${session.get('pseudoUser')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
                  child: Text(
                    'Paramètres du compte',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: [
                  CaseCompte(
                    'Modifier le profil',
                    redirection: const ModifProfilPage(),
                  ),
                  CaseCompte(
                    'Changer le mot de passe',
                    redirection: const ModifPasswordPage(),
                  ),
                  CaseCompte("Supprimer votre compte"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
