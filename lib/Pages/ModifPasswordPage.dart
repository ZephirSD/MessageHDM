import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Composants/InputForm.dart';
import '../Ressources/couleurs.dart';
import 'ComptePage.dart';
import 'package:http/http.dart' as http;

class ModifPasswordPage extends StatelessWidget {
  const ModifPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModifPasswordContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';

TextEditingController _nouvPassword = TextEditingController();
TextEditingController _confirmPassword = TextEditingController();

class ModifPasswordContainer extends StatefulWidget {
  const ModifPasswordContainer({super.key});

  @override
  State<ModifPasswordContainer> createState() => _ModifPasswordContainerState();
}

class _ModifPasswordContainerState extends State<ModifPasswordContainer> {
  modificationPassword() async {
    if (_nouvPassword.text == _confirmPassword.text) {
      var url =
          Uri.parse('$_rpcUrl/api/modifPassword/${session.get('idUser')}');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.get('tokenUser')}'
      };
      var request = http.Request('PUT', url);
      request.body = json.encode({
        "passwordUser": _nouvPassword.text,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var streamReponse = await http.Response.fromStream(response);
        var message = json.decode(streamReponse.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message["message"]),
          ),
        );
        Timer(Duration(seconds: 2), () {
          _nouvPassword.clear();
          _confirmPassword.clear();
          Navigator.pushReplacement(
            context as BuildContext,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => ComptePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        });
      } else {
        print(response.reasonPhrase);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mot de passe incorrect"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CouleursPrefs.couleurPrinc,
        shadowColor: Colors.transparent,
        title: Text('Modifier le mot de passe'),
        leading: ElevatedButton(
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => ComptePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            ),
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CouleursPrefs.couleurPrinc,
            shadowColor: Colors.transparent,
          ),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        color: CouleursPrefs.couleurPrinc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: InputModifForm(
                      "Nouveau mot de passe",
                      _nouvPassword,
                      modePassword: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: InputModifForm(
                      "Confirmer le mot de passe",
                      _confirmPassword,
                      modePassword: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            CouleursPrefs.couleurRose),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      child: Text(
                        'Modifier',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        modificationPassword();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
