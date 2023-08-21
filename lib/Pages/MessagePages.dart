import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:messagehdm/Composants/BulleMessage.dart';
import 'package:messagehdm/Composants/Messages/messages_class.dart';
import 'package:session_next/session_next.dart';
import 'package:http/http.dart' as http;
import '../Ressources/couleurs.dart';
import 'EvenementAccueil.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:open_app_file/open_app_file.dart';

TextEditingController _messagesEnvoi = TextEditingController();
ScrollController _scrollController = ScrollController();

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
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
var session = SessionNext();
PlatformFile? file;
Future<List<Messages>> fetchMessages() async {
  var eventString = session.get('event');
  var url = Uri.parse('$_rpcUrl/api/messages/$eventString');
  List<Messages> messages = [];
  messages.clear();
  var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
  var request = http.Request('GET', url);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var streamReponse = await http.Response.fromStream(response);

  List<int> transformListBin(var value) {
    List<dynamic> bufferDynamic = value;
    List<int> bufferInt = bufferDynamic.map((e) => e as int).toList();
    return bufferInt;
  }

  if (response.statusCode == 200) {
    var jsonList = json.decode(streamReponse.body);
    if (jsonList["result"] is List<dynamic>) {
      for (final listMessages in jsonList["result"]) {
        messages.add(
          Messages(
            auteur: listMessages["auteur"],
            texte: listMessages["texte"] ?? "",
            dateEnvoi: listMessages["date_envoi"],
            document: listMessages["document"] != null
                ? transformListBin(listMessages["document"]['data'])
                : null,
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
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${session.get('tokenUser')}'
  };
  if (_messagesEnvoi.text.isNotEmpty) {
    var requestMessage =
        http.Request('POST', Uri.parse('$_rpcUrl/api/messages'));
    requestMessage.body = json.encode({
      "auteur": session.get("pseudoUser"),
      "evenement": session.get("event"),
      "status": "lu",
      "texte": _messagesEnvoi.text,
      "date_envoi": DateTime.now().toString()
    });
    requestMessage.headers.addAll(headers);
    http.StreamedResponse response = await requestMessage.send();

    if (response.statusCode == 200) {
      _messagesEnvoi.clear();
    } else {
      print(response.reasonPhrase);
      _messagesEnvoi.clear();
    }
  } else if (file != null) {
    File fileDire = File(file!.path.toString());
    var requestMessage =
        http.Request('POST', Uri.parse('$_rpcUrl/api/messages'));
    requestMessage.body = json.encode({
      "auteur": session.get("pseudoUser"),
      "evenement": session.get("event"),
      "date_envoi": DateTime.now().toString(),
      "lien_fichier": file!.path.toString(),
      "nom_fichier": fileDire.path.split('/').last.split('.').first,
      "extension": fileDire.path.split('/').last.split('.').last.toLowerCase(),
      "idUser": session.get("idUser"),
    });
    requestMessage.headers.addAll(headers);
    http.StreamedResponse response = await requestMessage.send();

    if (response.statusCode == 200) {
      _messagesEnvoi.clear();
      file = null;
    } else {
      print(response.reasonPhrase);
      _messagesEnvoi.clear();
      file = null;
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
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = result.files.first;
      });
      // file == null ? false : OpenAppFile.open(file!.path.toString());
      print(file!.path.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CouleursPrefs.couleurPrinc,
          shadowColor: Colors.transparent,
          title: Text(widget.titreEvent),
          leading: ElevatedButton(
            onPressed: () => {
              session.remove('event'),
              file = null,
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventPageAccueil(),
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
        body: StreamBuilder(
            stream: getMessages(Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.hasData || snapshot.data != null) {
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
                        session.get("pseudoUser"),
                        binaryImage: message.document,
                      );
                    },
                  ),
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
            }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              file != null
                  ? Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.transparent,
                      ),
                      child: Image.asset(
                        file!.path.toString(),
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        border: Border.all(
                            color: CouleursPrefs.couleurPrinc, width: 1),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                            height: 10,
                          ),
                          SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                pickFile();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: const Icon(
                                  Icons.file_present_sharp,
                                  color: CouleursPrefs.couleurPrinc,
                                ),
                              ),
                            ),
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
                        color: CouleursPrefs.couleurPrinc,
                        shape: BoxShape.circle),
                    child: InkWell(
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                      onTap: () {
                        // SchedulerBinding.instance.addPostFrameCallback((_) {
                        //   _scrollController.animateTo(
                        //       _scrollController.position.maxScrollExtent,
                        //       duration: const Duration(milliseconds: 1),
                        //       curve: Curves.fastOutSlowIn);
                        // });
                        envoiMessage();
                        setState(() {
                          file = null;
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
