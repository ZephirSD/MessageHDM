import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:session_next/session_next.dart';
import '../Composants/Fonctions/FunctFetchDataDocument.dart';
import '../Composants/FutureFetchDoc.dart';
import '../Ressources/couleurs.dart';
import 'package:http/http.dart' as http;

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
PlatformFile? file;

class DocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DocumentHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

var session = SessionNext();

class DocumentHome extends StatefulWidget {
  @override
  State<DocumentHome> createState() => _DocumentHomeState();
}

class _DocumentHomeState extends State<DocumentHome> {
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

  Future<File> saveFile(PlatformFile file) async {
    final fileStock = await getApplicationDocumentsDirectory();
    final newFile = File('${fileStock.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  envoiDocuments() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.get('tokenUser')}'
    };
    var request = http.Request('POST', Uri.parse('${_rpcUrl}/api/documents'));

    if (file != null) {
      File? fileDire = null;
      if (Platform.isAndroid) {
        final newFile = await saveFile(file!);
        fileDire = File(newFile.path.toString());
      } else {
        fileDire = File(file!.path.toString());
      }
      request.body = json.encode({
        "lien_fichier": file!.path.toString(),
        "nom_fichier": fileDire.path.split('/').last.split('.').first,
        "extension":
            fileDire.path.split('/').last.split('.').last.toLowerCase(),
        "idUser": session.get("idUser"),
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var streamReponse = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        file = null;
        var message = json.decode(streamReponse.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message["result"]),
          ),
        );
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context as BuildContext,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => DocumentHome(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        });
      } else {
        print(response.reasonPhrase);
        file = null;
      }
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CouleursPrefs.couleurPrinc,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Align(
                alignment: AlignmentDirectional(-0.65, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Documents',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            CouleursPrefs.couleurGrisClair),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      await pickFile();
                      if (file != null) {
                        envoiDocuments();
                      }
                    },
                    child: Text('Ajouter un document')),
              ),
              Column(
                children: [
                  FutureFetchDoc(
                    "Documents récents",
                    functFetch: fetchDocuments(_rpcUrl, session),
                  )
                ],
              ),
              Column(
                children: [
                  const Align(
                    alignment: AlignmentDirectional(-0.65, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                      child: Text(
                        'Listes des documents',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  FutureFetchDoc("PDF",
                      functFetch: fetchDocumentsPDF(_rpcUrl, session)),
                  FutureFetchDoc("Images",
                      functFetch: fetchDocumentsImages(_rpcUrl, session)),
                  FutureFetchDoc("Word",
                      functFetch: fetchDocumentsWord(_rpcUrl, session)),
                  FutureFetchDoc("Excel",
                      functFetch: fetchDocumentsExcel(_rpcUrl, session)),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
