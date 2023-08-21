import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:session_next/session_next.dart';
import '../Composants/Fonctions/FunctFetchDataDocument.dart';
import '../Composants/FutureFetchDoc.dart';
import '../Ressources/couleurs.dart';
import 'package:http/http.dart' as http;

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';

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
  envoiDocuments() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDc4NzQxMDNhMzg4YWNiNDIzMzEyZmYiLCJwc2V1ZG8iOiJ0ZXN0IiwiaWF0IjoxNjg3NzcxOTYxLCJleHAiOjE2OTAzNjM5NjF9.WIG_RbC4KOH7CP2JrDvvVZMFomyXQcrKd8N3jyGhZHo'
    };
    var request =
        http.Request('POST', Uri.parse('https://localhost:8000/api/documents'));
    request.body = json.encode({
      "nom_fichier": "Calendrier CDA 2023",
      "extension": "pdf",
      "idUser": "6478377caed27755fa0cf850",
      "lien_fichier":
          "/Users/siegfrieddallery/Library/Mobile Documents/com~apple~CloudDocs/OSIPRO Concepteur d’application mobile/Calendrier CDA 3.pdf"
    });
    request.headers.addAll(headers);

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
                padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                child: TextFormField(
                  //controller: _model.textController,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Document à rechercher',
                    hintStyle: const TextStyle(
                      fontFamily: 'Lexend Deca',
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    filled: true,
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {}, child: Text('Ajouter un document')),
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
