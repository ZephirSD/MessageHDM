import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/utils.dart';
// import 'package:flutter/scheduler.dart';
import 'package:messagehdm/Composants/BulleMessage.dart';
import 'package:messagehdm/Composants/Fonctions/FunctFetchEvenements.dart';
import 'package:messagehdm/Composants/InputForm.dart';
import 'package:messagehdm/Composants/Messages/messages_class.dart';
import 'package:messagehdm/Ressources/routes.dart';
import 'package:session_next/session_next.dart';
import 'package:http/http.dart' as http;
import '../Composants/Fonctions/FunctFetchUtilisateurs.dart';
import '../Composants/InputMentionUser.dart';
import '../Ressources/couleurs.dart';
import 'EvenementAccueil.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:open_app_file/open_app_file.dart';

TextEditingController _messagesEnvoi = TextEditingController();
TextEditingController _invites = TextEditingController();
ScrollController _scrollController = ScrollController();
TextEditingController _nomEvent = TextEditingController();

List<String> _listMentions = [];
String elementPseudo = "";

class MessagePage extends StatelessWidget {
  final String titreEvent;
  final String idEvent;
  final String modeEvent;
  MessagePage(this.titreEvent, this.idEvent, this.modeEvent);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessageHome(titreEvent, idEvent, modeEvent),
      debugShowCheckedModeBanner: false,
    );
  }
}

var session = SessionNext();
PlatformFile? file;
var headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${session.get('tokenUser')}'
};
Future<List<Messages>> fetchMessages() async {
  var eventString = session.get('event');
  var url = Uri.parse('${Routes.rLocalURL}/api/messages/$eventString');
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

functValueChange(String value) {
  List<String> userList = value.trim().split('@').skip(1).toList();
  _listMentions = userList;
  print(_listMentions);
}

functArrayPseudo() async {
  List<dynamic> data = await fetchGetPseudo(session.get("event"));
  List pseudoList = data.map((item) => '@${item['display']}').toList();
  String stringPseudo = pseudoList.join(' ');
  elementPseudo = stringPseudo;
}

envoiMessage() async {
  if (_messagesEnvoi.text.isNotEmpty) {
    var requestMessage =
        http.Request('POST', Uri.parse('${Routes.rLocalURL}/api/messages'));
    requestMessage.body = json.encode({
      "auteur": session.get("pseudoUser"),
      "evenement": session.get("event"),
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
        http.Request('POST', Uri.parse('${Routes.rLocalURL}/api/messages'));
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
  final String idEvent;
  final String modeEvent;
  MessageHome(this.titreEvent, this.idEvent, this.modeEvent);

  @override
  State<MessageHome> createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  void initState() {
    // TODO: implement initState
    _nomEvent.text = widget.titreEvent;
    functArrayPseudo();
    super.initState();
  }

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

  modifEvenement() async {
    var request = http.Request(
        'PUT',
        Uri.parse(
            '${Routes.rLocalURL}/api/evenements/modif-event/${session.get('event')}'));
    request.body = json.encode({"nom_event": _nomEvent.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              MessagePage(_nomEvent.text, widget.idEvent, widget.modeEvent),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
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
          title: Text(widget.titreEvent),
          leading: ElevatedButton(
            onPressed: () => {
              session.remove('event'),
              session.remove('adminEvent'),
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
          actions: [
            session.get('adminEvent') == session.get("email")
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          CouleursPrefs.couleurGrisFonce),
                    ),
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (BuildContext buildContext,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return Portal(
                            child: MaterialApp(
                              debugShowCheckedModeBanner: false,
                              home: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: Scaffold(
                                    appBar: AppBar(
                                      leading: ElevatedButton(
                                        onPressed: () => {
                                          Navigator.of(buildContext).pop(),
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          color: CouleursPrefs.couleurBlanc,
                                        ),
                                      ),
                                      backgroundColor:
                                          CouleursPrefs.couleurPrinc,
                                      shadowColor: Colors.transparent,
                                      title: Text(
                                        'Admin de ${widget.titreEvent}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                      centerTitle: true,
                                    ),
                                    body: Container(
                                      decoration: BoxDecoration(
                                        color: CouleursPrefs.couleurPrinc,
                                      ),
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: InputForm(
                                                  "Nom de l'évènement",
                                                  _nomEvent)),
                                          widget.modeEvent == "prive"
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: FutureBuilder(
                                                    future: fetchGetPseudo(
                                                        session.get('event')),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                List<dynamic>>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        final jsonData =
                                                            snapshot.data;
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            listJsonUser =
                                                            jsonData!
                                                                .map((item) =>
                                                                    item as Map<
                                                                        String,
                                                                        dynamic>)
                                                                .toList();
                                                        if (snapshot.data ==
                                                            null) {
                                                          return const Center(
                                                            child: Text(
                                                                'Something went wrong'),
                                                          );
                                                        }
                                                        return InputMentionUser(
                                                          Routes.rLocalURL,
                                                          listJsonUser,
                                                          functValueChange,
                                                          labelInput:
                                                              "Ajouter un utilisateur à déléguer",
                                                          position:
                                                              SuggestionPosition
                                                                  .Top,
                                                        );
                                                      }
                                                      return Center(
                                                        child:
                                                            const CircularProgressIndicator(),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          widget.modeEvent == "prive"
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: FutureBuilder(
                                                    future:
                                                        fetchGetAllUtilisateurs(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                List<dynamic>>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        final jsonData =
                                                            snapshot.data;
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            listJsonUser =
                                                            jsonData!
                                                                .map((item) =>
                                                                    item as Map<
                                                                        String,
                                                                        dynamic>)
                                                                .toList();
                                                        if (snapshot.data ==
                                                            null) {
                                                          return const Center(
                                                            child: Text(
                                                                'Something went wrong'),
                                                          );
                                                        }
                                                        return InputMentionUser(
                                                          Routes.rLocalURL,
                                                          listJsonUser,
                                                          functValueChange,
                                                          optionTexte:
                                                              '${elementPseudo} ',
                                                          position:
                                                              SuggestionPosition
                                                                  .Bottom,
                                                        );
                                                      }
                                                      return Center(
                                                        child:
                                                            const CircularProgressIndicator(),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        CouleursPrefs
                                                            .couleurRose),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                //functArrayPseudo();
                                                // modifEvenement();
                                                // Navigator.of(buildContext)
                                                //     .pop();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25,
                                                        vertical: 5),
                                                child: const Text("Modifier"),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.settings,
                      color: CouleursPrefs.couleurBlanc,
                    ))
                : Container()
          ],
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
