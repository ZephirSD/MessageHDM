import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/InputForm.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../Composants/NavHomeBottom.dart';

class NewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('fr')],
      home: NewEventContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewEventContainer extends StatefulWidget {
  @override
  State<NewEventContainer> createState() => _NewEventContainerState();
}

class _NewEventContainerState extends State<NewEventContainer> {
  int _selectedIndex = 0;
  final _formEvent = GlobalKey<FormState>();
  final _nomEvent = TextEditingController();
  final _dateDeb = TextEditingController();
  final _dateFin = TextEditingController();
  String selectedValue = "public";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Public"), value: "public"),
      DropdownMenuItem(child: Text("Privé"), value: "prive"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: NavHomeBottom(
        _selectedIndex,
      ),
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
                          builder: (context) => const EventPageAccueil(),
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
              color: Colors.white,
              child: Form(
                key: _formEvent,
                child: Column(
                  children: [
                    InputForm("Nom de l'évènement",
                        Icon(Icons.text_fields_sharp), _nomEvent),
                    TextField(
                      controller: _dateDeb,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Date de début de l'inscription"),
                      readOnly: true,
                      onTap: () async {
                        showDatePicker(
                          context: context,
                          locale: const Locale("fr", "FR"),
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2200),
                        );
                      },
                    ),
                    TextField(
                      controller: _dateFin,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Date de fin de l'inscription"),
                      readOnly: true,
                      onTap: () async {
                        showDatePicker(
                          context: context,
                          locale: const Locale("fr", "FR"),
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2200),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text("Mode de l'évènement"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: DropdownButton(
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
                      onPressed: () => {},
                      child: Text("Créer"),
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
