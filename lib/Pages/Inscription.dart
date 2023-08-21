import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messagehdm/Pages/Connexion.dart';
import 'dart:convert';
import '../Composants/InputForm.dart';
import '../Ressources/couleurs.dart';
import '../main.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InscriptionContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InscriptionContainer extends StatefulWidget {
  const InscriptionContainer({super.key});

  @override
  State<InscriptionContainer> createState() => _InscriptionContainerState();
}

class _InscriptionContainerState extends State<InscriptionContainer> {
  final _formInscr = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pseudo = TextEditingController();
  final _passwordUser = TextEditingController();
  final _passwordValid = TextEditingController();
  final _telephone = TextEditingController();
  final String _rpcUrl =
      Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';

  clearControllers() {
    _email.clear();
    _pseudo.clear();
    _passwordUser.clear();
    _passwordValid.clear();
    _telephone.clear();
  }

  inscri() async {
    // print(_pseudo.text);
    // print(_email.text);
    // print(_passwordUser.text);
    // print(_telephone.text);
    var url = Uri.parse('${_rpcUrl}/api/inscrip');
    if (_passwordUser.text == _passwordValid.text) {
      var body = {
        "pseudo": _pseudo.text,
        "email": _email.text,
        "passwordUser": _passwordUser.text,
        "telephone": _telephone.text
      };
      http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: json.encode(body))
          .then((response) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vous êtez inscrit ${_pseudo.text}'),
            ),
          );
          clearControllers();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConnexionPage()),
          );
        } else {
          var message = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message["message"]),
            ),
          );
          clearControllers();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mot de passe incorrecte'),
        ),
      );
      _passwordUser.clear();
      _passwordValid.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CouleursPrefs.couleurPrinc,
        shadowColor: Colors.transparent,
        leading: ElevatedButton(
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => MyApp(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            ),
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        color: CouleursPrefs.couleurPrinc,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              key: _formInscr,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: InputForm(
                      "Email",
                      _email,
                      iconInput: Icon(Icons.email_rounded),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: InputForm(
                      "Pseudo",
                      _pseudo,
                      iconInput: Icon(Icons.account_box_rounded),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: InputForm(
                      "Nouveau mot de passe",
                      _passwordUser,
                      hiddenPassword: true,
                      iconInput: Icon(Icons.password_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: InputForm(
                      "Confirmer le mot de passe",
                      _passwordValid,
                      hiddenPassword: true,
                      iconInput: Icon(Icons.password_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: InputForm(
                      "Téléphone",
                      _telephone,
                      iconInput: Icon(Icons.phone_rounded),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      inscri();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple),
                      shadowColor: MaterialStatePropertyAll(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: const Text('Inscrire'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
