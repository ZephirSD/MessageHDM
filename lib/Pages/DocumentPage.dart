import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/CaseDocument.dart';
import 'package:messagehdm/Composants/Documents/documents_class.dart';
import 'package:session_next/session_next.dart';
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
  List<Documents> listDocuments = [];
  Future<List<Documents>> fetchDocuments() async {
    var url =
        Uri.parse('${_rpcUrl}/api/documents/recents/${session.get("idUser")}');
    var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
    var request = http.Request('GET', url);
    request.headers.addAll(headers);
    listDocuments.clear();
    http.StreamedResponse response = await request.send();
    var streamReponse = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      return Documents.fromJsonList(json.decode(streamReponse.body));
    } else {
      print(response.reasonPhrase);
      throw Exception('Request Failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
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
                //style: FlutterFlowTheme.of(context).bodyMedium,
                // validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
            Column(
              children: [
                const Align(
                  alignment: AlignmentDirectional(-0.65, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Documents récents',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 200,
                    child: FutureBuilder(
                      future: fetchDocuments(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Documents>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text('Aucune donnée reçu'),
                            );
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return CaseDocuments(
                                    snapshot.data![index].nomFichier,
                                    snapshot.data![index].extensionFichier,
                                    snapshot.data![index].idDoc,
                                    snapshot.data![index].dataDocument);
                              });
                        }
                        return Center(
                          child: const CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
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
                      'Liste des documents',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 200,
                    color: Colors.deepPurple,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
