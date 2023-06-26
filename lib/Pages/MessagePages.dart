import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/BulleMessage.dart';
import 'package:messagehdm/Composants/Messages/messages_class.dart';
import 'package:session_next/session_next.dart';
import 'package:http/http.dart' as http;
import 'EvenementAccueil.dart';

TextEditingController _messagesEnvoi = TextEditingController();

class MessagePage extends StatelessWidget {
  final String titreEvent;
  MessagePage(this.titreEvent);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessageHome(titreEvent),
      debugShowCheckedModeBanner: false,
    );
  }
}

final String _rpcUrl =
    Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
var session = SessionNext();
Future<List<Messages>> fetchMessages() async {
  var eventString = session.get('event');
  var url = Uri.parse('${_rpcUrl}/api/messages/${eventString}');
  List<Messages> messages = [];
  messages.clear();
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    var jsonList = json.decode(streamReponse.body);
    if (jsonList["result"] is List<dynamic>) {
      for (final listMessages in jsonList["result"]) {
        messages.add(
          Messages(
            auteur: listMessages["auteur"],
            texte: listMessages["texte"],
            dateEnvoi: listMessages["date_envoi"],
            status: listMessages["status"],
            evenement: listMessages["evenement"],
          ),
        );
      }
    }
    return messages;
  } else {
    throw Exception('Request Failed.');
  }
}

envoiMessage() async {
  if (_messagesEnvoi.text.isNotEmpty) {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.get('tokenUser')}'
    };
    var request =
        http.Request('POST', Uri.parse('http://localhost:8000/api/messages'));
    request.body = json.encode({
      "auteur": session.get("pseudoUser"),
      "evenement": session.get("event"),
      "status": "lu",
      "texte": _messagesEnvoi.text,
      "date_envoi": DateTime.now().toString()
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _messagesEnvoi.clear();
    } else {
      print(response.reasonPhrase);
      _messagesEnvoi.clear();
    }
  }
}

Stream<List<Messages>> getMessages(Duration refreshTime) async* {
  while (true) {
    await Future.delayed(refreshTime);
    yield await fetchMessages();
  }
}

class MessageHome extends StatefulWidget {
  final String titreEvent;
  MessageHome(this.titreEvent);

  @override
  State<MessageHome> createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          shadowColor: Colors.transparent,
          title: Text(widget.titreEvent),
          leading: ElevatedButton(
            onPressed: () => {
              session.remove('event'),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventPageAccueil(),
                ),
              ),
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shadowColor: Colors.transparent,
            ),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: StreamBuilder(
            stream: getMessages(Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    reverse: false,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return BulleMessage(
                          message.texte,
                          DateTime.parse(message.dateEnvoi),
                          message.auteur,
                          session.get("pseudoUser"));
                    },
                  ),
                );
              } else {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey,
                    ),
                  ),
                );
              }
            }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      border: Border.all(color: Colors.blueGrey, width: 1)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messagesEnvoi,
                          decoration: InputDecoration(
                              hintText: "Entrez votre message...",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Colors.blueGrey, shape: BoxShape.circle),
                child: InkWell(
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {
                    envoiMessage();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
