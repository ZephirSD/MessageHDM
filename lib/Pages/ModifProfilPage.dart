import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/InputForm.dart';
import 'package:messagehdm/Composants/Utilisateurs/utilisateurs_class.dart';
import 'package:messagehdm/Pages/ComptePage.dart';
import 'package:session_next/session_next.dart';

import '../Ressources/couleurs.dart';

class ModifProfilPage extends StatelessWidget {
  const ModifProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModifProfilContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';

TextEditingController _emailModif = TextEditingController();
TextEditingController _pseudoModif = TextEditingController();
TextEditingController _telephoneModif = TextEditingController();

// List<Utilisateur>? lsitUser;

class ModifProfilContainer extends StatefulWidget {
  const ModifProfilContainer({super.key});

  @override
  State<ModifProfilContainer> createState() => _ModifProfilContainerState();
}

class _ModifProfilContainerState extends State<ModifProfilContainer> {
  var session = SessionNext();
  // var url = Uri.parse('${_rpcUrl}/api/evenements/');

  Future<Utilisateur> fetchGetUtilisateurs() async {
    var url = Uri.parse('$_rpcUrl/api/getUser/${session.get('idUser')}');
    var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
    var request = http.Request('GET', url);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var streamReponse = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      var jsonUser = json.decode(streamReponse.body);
      _emailModif.text = jsonUser["result"]["email"].toString();
      _pseudoModif.text = jsonUser["result"]["pseudo"].toString();
      _telephoneModif.text = jsonUser["result"]["telephone"].toString();
      return Utilisateur.fromJson(jsonUser);
    } else {
      throw Exception('Request Failed.');
    }
  }

  modificationCompte() async {
    var url = Uri.parse('$_rpcUrl/api/modifUser/${session.get('idUser')}');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.get('tokenUser')}'
    };
    var request = http.Request('PUT', url);
    request.body = json.encode({
      "email": _emailModif.text,
      "emailSession": session.get('email'),
      "pseudo": _pseudoModif.text,
      "pseudoSession": session.get('pseudoUser'),
      "telephone": _telephoneModif.text
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
      session.setAll({
        'pseudoUser': _pseudoModif.text,
        'email': _emailModif.text,
        'phoneUser': _telephoneModif.text
      });
      session.update();
      Timer(Duration(seconds: 2), () {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CouleursPrefs.couleurPrinc,
        shadowColor: Colors.transparent,
        title: Text('Modifier le profil'),
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
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.white,
            ),
            Container(
              child: FutureBuilder(
                future: fetchGetUtilisateurs(),
                builder: (context, AsyncSnapshot<Utilisateur> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Center(
                          child: Text('Aucune donnée disponible'));
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: InputModifForm(
                            "Email",
                            _emailModif,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: InputModifForm(
                            "Pseudo",
                            _pseudoModif,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: InputModifForm(
                            "Téléphone",
                            _telephoneModif,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                },
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
                        'Enregistrer',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        modificationCompte();
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
