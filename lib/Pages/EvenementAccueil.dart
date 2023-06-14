import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/Evenements/evenements_class.dart';
import '../Composants/CaseEvent.dart';
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
    Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

class EventContainerAccueil extends StatefulWidget {
  @override
  State<EventContainerAccueil> createState() => _EventContainerAccueilState();
}

class _EventContainerAccueilState extends State<EventContainerAccueil> {
  var session = SessionNext();
  var url = Uri.parse('${_rpcUrl}/api/evenements/');

  Future<List<Evenements>> fetchEvenement() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Evenements.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Request Failed.');
    }
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bonjour ${session.get("pseudoUser")}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
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
                        Navigator.pushReplacement(
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
            Expanded(
              child: FutureBuilder(
                future: fetchEvenement(),
                builder: (context, AsyncSnapshot<List<Evenements>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return CaseEvent(snapshot.data![index].nomEvent);
                        });
                  }
                  return const CircularProgressIndicator();
                },
              ),
            )
          ],
        ));
  }
}
