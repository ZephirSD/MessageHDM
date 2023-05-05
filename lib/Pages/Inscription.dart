import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final _passwordVisible = false;
  inscri() async {
    print(_pseudo.text);
    print(_email.text);
    print(_passwordUser.text);
    print(_telephone.text);
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://127.0.0.1:8000/api/inscrip'));
    request.body = json.encode({
      "pseudo": _pseudo.text,
      "email": _email.text,
      "passwordUser": _passwordUser.text,
      "telephone": _telephone.text
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
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
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email_rounded),
                      ),
                    ),
                    TextFormField(
                      controller: _pseudo,
                      decoration: InputDecoration(
                        labelText: 'Pseudo',
                        icon: Icon(Icons.account_box_rounded),
                      ),
                    ),
                    TextFormField(
                      obscureText: !_passwordVisible,
                      controller: _passwordUser,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        icon: Icon(Icons.password_rounded),
                      ),
                    ),
                    TextFormField(
                      controller: _telephone,
                      decoration: InputDecoration(
                        labelText: 'Téléphone',
                        icon: Icon(Icons.phone_rounded),
                      ),
                    ),
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
