import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:messagehdm/Pages/SwitchPage.dart';
import '../Composants/InputForm.dart';
import 'package:session_next/session_next.dart';

class ConnexionPage extends StatelessWidget {
  const ConnexionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConnexionContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConnexionContainer extends StatefulWidget {
  const ConnexionContainer({super.key});

  @override
  State<ConnexionContainer> createState() => _ConnexionContainerState();
}

class _ConnexionContainerState extends State<ConnexionContainer> {
  var session = SessionNext();
  final _formConnex = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _passwordUser = TextEditingController();
  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
  clearControllers() {
    _email.clear();
    _passwordUser.clear();
  }

  connect() async {
    var body = {
      "email": _email.text,
      "passwordUser": _passwordUser.text,
    };
    var url = Uri.parse('${_rpcUrl}/api/connec');
    http
        .post(url,
            headers: {"Content-Type": "application/json"},
            body: json.encode(body))
        .then((response) {
      print(response.statusCode);
      var message = json.decode(response.body);
      if (response.statusCode == 200) {
        session.setAll({
          'tokenUser': message["token"],
          'pseudoUser': message["user"]["pseudo"],
          'idUser': message["user"]["_id"],
          'email': message["user"]["email"],
        });
        print(session.get("idUser"));
        print(session.get("tokenUser"));
        print(session.get("pseudoUser"));
        print(session.get("email"));
        clearControllers();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SwitchPage()),
        // );
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SwitchPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
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
                key: _formConnex,
                child: Column(
                  children: [
                    InputForm("Email", Icon(Icons.email_rounded), _email),
                    InputForm(
                      "Mot de passe",
                      Icon(Icons.password_rounded),
                      _passwordUser,
                      hiddenPassword: true,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        connect();
                      },
                      child: const Text('Se connecter'),
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
