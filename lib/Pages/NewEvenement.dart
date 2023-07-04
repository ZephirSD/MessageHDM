import 'dart:convert';
import 'dart:io';
// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/InputDateFin.dart';
import 'package:messagehdm/Composants/InputForm.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:session_next/session_next.dart';
// import 'package:simple_localization/simple_localization.dart';
import '../Composants/InputDateDebut.dart';
// import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
      home: NewEventContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final _formEvent = GlobalKey<FormState>();
final _nomEvent = TextEditingController();
final _dateDeb = TextEditingController();
final _dateFin = TextEditingController();
String selectedValue = "public";
final String _rpcUrl =
    Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
var session = SessionNext();

clearControllers() {
  _nomEvent.clear();
  _dateDeb.clear();
  _dateFin.clear();
}

envoiEvenement() async {
  if (_dateDeb.text.isEmpty &&
      _dateFin.text.isEmpty &&
      _nomEvent.text.isEmpty) {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.get('tokenUser')}'
    };
    var request = http.Request(
        'POST', Uri.parse('https://localhost:8000/api/evenements'));
    if (selectedValue == 'public') {
      request.body = json.encode({
        "nom_event": _nomEvent.text,
        "date_debut": _dateDeb.text,
        "date_fin": _dateFin.text,
        "mode_event": selectedValue,
        "create_event": session.get('email')
      });
    } else {
      // request.body = json.encode({
      //   "nom_event": _nomEvent.text,
      //   "date_debut": _dateDeb.text,
      //   "date_fin": _dateFin.text,
      //   "mode_event": selectedValue,
      //   "create_event": session.get('email')
      // });
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      clearControllers();
      // Navigator.pushReplacement(
      //   context as BuildContext,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => EventPageAccueil(),
      //     transitionDuration: Duration.zero,
      //     reverseTransitionDuration: Duration.zero,
      //   ),
      // );
    } else {
      print(response.reasonPhrase);
    }
  }
}

class NewEventContainer extends StatefulWidget {
  @override
  State<NewEventContainer> createState() => _NewEventContainerState();
}

class _NewEventContainerState extends State<NewEventContainer> {
  // int _selectedIndex = 0;
  DateTime? _selectedDateDeb = null;
  DateTime? _selectedDateFin = null;
  // DateTime? _selectedDate = null;
  // final _formEvent = GlobalKey<FormState>();
  // final _nomEvent = TextEditingController();
  // final _dateDeb = TextEditingController();
  // final _dateFin = TextEditingController();
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Public"), value: "public"),
      DropdownMenuItem(child: Text("Privé"), value: "prive"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
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
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPageAccueil(),
                        ),
                      ),
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blueGrey,
              child: Form(
                key: _formEvent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: InputForm("Nom de l'évènement",
                          const Icon(Icons.text_fields_sharp), _nomEvent),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: InputDateDebut(_dateDeb, _selectedDateDeb,
                          "Date de début de l'inscription"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: InputDateFin(_dateFin, _selectedDateFin,
                          "Date de fin de l'inscription"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "Mode de l'évènement",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: DropdownButton(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            value: selectedValue,
                            items: dropdownItems,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.deepPurple),
                        shadowColor:
                            MaterialStatePropertyAll(Colors.transparent),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: const Text("Créer"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
