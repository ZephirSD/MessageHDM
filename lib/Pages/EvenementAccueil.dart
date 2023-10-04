import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/Evenements/evenements_class.dart';
import '../Composants/CaseEvent.dart';
import '../Ressources/couleurs.dart';
import 'NewEvenement.dart';
import 'package:http/http.dart' as http;
import 'package:session_next/session_next.dart';

class EventPageAccueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventContainerAccueil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';

class EventContainerAccueil extends StatefulWidget {
  @override
  State<EventContainerAccueil> createState() => _EventContainerAccueilState();
}

class _EventContainerAccueilState extends State<EventContainerAccueil> {
  var session = SessionNext();
  var url = Uri.parse('${_rpcUrl}/api/evenements/event-invite');

  Future<List<Evenements>> fetchEvenement() async {
    var headers = {
      'Authorization': 'Bearer ${session.get('tokenUser')}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', url);
    request.body = json.encode({
      "createEvent": session.get('email'),
      "pseudoEvent": session.get('pseudoUser')
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var streamReponse = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return Evenements.fromJsonList(json.decode(streamReponse.body));
    } else {
      throw Exception('Request Failed.');
    }
  }

  Stream<List<Evenements>> getEvenements(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await fetchEvenement();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CouleursPrefs.couleurPrinc,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Bonjour ${session.get("pseudoUser")}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                NewEventPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        ),
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: getEvenements(Duration(seconds: 1)),
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.data != null) {
                    final events = snapshot.data!;
                    return ListView.builder(
                      reverse: false,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return CaseEvent(
                          event.nomEvent,
                          event.idEvent,
                          event.modeEvent,
                          admimEvent: event.createEvent,
                        );
                      },
                    );
                  } else {
                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CouleursPrefs.couleurPrinc,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
