import 'package:flutter/material.dart';
import 'package:messagehdm/Ressources/couleurs.dart';
import 'CaseDocument.dart';
import 'Documents/documents_class.dart';

class FutureFetchDoc extends StatefulWidget {
  final Future<List<Documents>>? functFetch;
  final String titre;
  FutureFetchDoc(this.titre, {this.functFetch});

  @override
  State<FutureFetchDoc> createState() => _FutureFetchDocState();
}

class _FutureFetchDocState extends State<FutureFetchDoc> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.65, 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      widget.titre,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: FutureBuilder(
                    future: widget.functFetch,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Documents>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null ||
                            snapshot.data?.length == 0) {
                          return Container(
                            color: CouleursPrefs.couleurGrisClair,
                            child: const Center(
                              child: Text(
                                'Aucun document',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return CaseDocuments(
                                  snapshot.data![index].nomFichier,
                                  snapshot.data![index].idDoc,
                                  snapshot.data![index].extensionFichier,
                                  snapshot.data![index].idDoc,
                                  snapshot.data![index].dataDocument);
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 14, 56, 129),
                          color: Color.fromARGB(255, 82, 111, 255),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
