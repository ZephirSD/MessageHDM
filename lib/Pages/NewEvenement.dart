import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/InputDateFin.dart';
import 'package:messagehdm/Composants/InputForm.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:session_next/session_next.dart';
// import 'package:simple_localization/simple_localization.dart';
import '../Composants/Fonctions/FunctFetchUtilisateurs.dart';
import '../Composants/InputDateDebut.dart';
// import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mentions/flutter_mentions.dart';
import '../Composants/InputMentionUser.dart';
import '../Ressources/couleurs.dart';

class NewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr')],
        home: NewEventContainer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// final _formEvent = GlobalKey<FormState>();
final _nomEvent = TextEditingController();
final _dateDeb = TextEditingController();
final _dateFin = TextEditingController();
List<String> _listMentions = [];

// final _userList = TextEditingController();
String selectedValue = "public";
final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
var session = SessionNext();

clearControllers() {
  _nomEvent.clear();
  _dateDeb.clear();
  _dateFin.clear();
}

class NewEventContainer extends StatefulWidget {
  @override
  State<NewEventContainer> createState() => _NewEventContainerState();
}

class _NewEventContainerState extends State<NewEventContainer> {
  DateTime? _selectedDateDeb = null;
  DateTime? _selectedDateFin = null;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Public"),
          ),
          value: "public"),
      DropdownMenuItem(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Privé"),
          ),
          value: "prive"),
    ];
    return menuItems;
  }

  functValueChange(String value) {
    List<String> userList = value.trim().split('@').skip(1).toList();
    _listMentions = userList;
    print(_listMentions);
  }

  envoiEvenement() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.get('tokenUser')}'
    };
    var request = http.Request('POST', Uri.parse('$_rpcUrl/api/evenements'));
    if (_nomEvent.text.isNotEmpty) {
      if (selectedValue == 'public') {
        request.body = json.encode({
          "nom_event": _nomEvent.text,
          "mode_event": selectedValue,
          "date_debut": DateTime.now().toString(),
          "date_fin": DateTime.now().toString(),
          "create_event": session.get('email')
        });
      } else {
        String dateDebUTC =
            DateFormat('dd/MM/yyyy').parse(_dateDeb.text).toString();
        String dateFinUTC =
            DateFormat('dd/MM/yyyy').parse(_dateFin.text).toString();

        List<Map<String, dynamic>> listEncodes = [];

        for (var list in _listMentions) {
          listEncodes.add({"pseudo": list.trim(), "accept": false});
        }

        String jsonListMentions = jsonEncode(listEncodes);

        request.body = json.encode({
          "nom_event": _nomEvent.text,
          "date_debut": dateDebUTC,
          "date_fin": dateFinUTC,
          "mode_event": selectedValue,
          "create_event": session.get('email'),
          "invite_prive": jsonDecode(jsonListMentions)
        });
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var streamReponse = await http.Response.fromStream(response);
        print(streamReponse.body);
        final responseData = json.decode(streamReponse.body);
        for (var list in _listMentions) {
          var request =
              http.Request('POST', Uri.parse('$_rpcUrl/api/notifications'));
          request.body = json.encode({
            "evenements": responseData["result"]["_id"],
            "type_notif": "invitation",
            "message_notif":
                'Vous êtes invité à l\'évènement ${_nomEvent.text}',
            "destin_notif": list.trim()
          });
          request.headers.addAll(headers);
          await request.send();
        }
        clearControllers();
        _listMentions.clear();
        selectedValue = "public";
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPageAccueil(),
          ),
        );
      } else {
        print(response.reasonPhrase);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veuillez mettre un nom d'évènement"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CouleursPrefs.couleurPrinc,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              CouleursPrefs.couleurGrisClair),
                        ),
                        onPressed: () => {
                          selectedValue = "public",
                          clearControllers(),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventPageAccueil(),
                            ),
                          ),
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: CouleursPrefs.couleurNoir,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: CouleursPrefs.couleurPrinc,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: InputForm(
                          "Nom de l'évènement",
                          _nomEvent,
                          iconInput: Icon(Icons.text_fields_sharp),
                        ),
                      ),
                      selectedValue == "prive"
                          ? (Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: InputDateDebut(_dateDeb, _selectedDateDeb,
                                  "Date de début de l'inscription"),
                            ))
                          : (Container()),
                      selectedValue == "prive"
                          ? (Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: InputDateFin(_dateFin, _selectedDateFin,
                                  "Date de fin de l'inscription"),
                            ))
                          : (Container()),
                      selectedValue == "prive"
                          ? (Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: FutureBuilder(
                                future: fetchGetAllUtilisateurs(),
                                builder: (context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final jsonData = snapshot.data;
                                    List<Map<String, dynamic>> listJsonUser =
                                        jsonData!
                                            .map((item) =>
                                                item as Map<String, dynamic>)
                                            .toList();
                                    if (snapshot.data == null) {
                                      return const Center(
                                        child: Text('Something went wrong'),
                                      );
                                    }
                                    return InputMentionUser(
                                      _rpcUrl,
                                      listJsonUser,
                                      functValueChange,
                                    );
                                  }
                                  return Center(
                                    child: const CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ))
                          : (Container()),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Mode de l'évènement",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButton(
                              value: selectedValue,
                              items: dropdownItems,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                  clearControllers();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                              CouleursPrefs.couleurRose),
                          shadowColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () => {
                          envoiEvenement(),
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Text("Créer"),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
