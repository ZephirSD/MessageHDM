import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messagehdm/Pages/Connexion.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
import 'dart:convert';
import '../Composants/InputForm.dart';

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
  final _telephone = TextEditingController();
  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

  clearControllers() {
    _email.clear();
    _pseudo.clear();
    _passwordUser.clear();
    _telephone.clear();
  }

  inscri() async {
    // print(_pseudo.text);
    // print(_email.text);
    // print(_passwordUser.text);
    // print(_telephone.text);
    var body = {
      "pseudo": _pseudo.text,
      "email": _email.text,
      "passwordUser": _passwordUser.text,
      "telephone": _telephone.text
    };
    var url = Uri.parse('${_rpcUrl}/api/inscrip');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blueGrey,
                ),
              ),
              Form(
                key: _formInscr,
                child: Column(
                  children: [
                    InputForm("Email", Icon(Icons.email_rounded), _email),
                    InputForm(
                        "Pseudo", Icon(Icons.account_box_rounded), _pseudo),
                    InputForm(
                      "Mot de passe",
                      Icon(Icons.password_rounded),
                      _passwordUser,
                      hiddenPassword: true,
                    ),
                    InputForm(
                        "Téléphone", Icon(Icons.phone_rounded), _telephone),
                    ElevatedButton(
                      onPressed: () {
                        inscri();
                      },
                      child: const Text('Inscrire'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
