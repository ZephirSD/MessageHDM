List<int> transformListBin(var value) {
  List<dynamic> bufferDynamic = value;
  List<int> bufferInt = bufferDynamic.map((e) => e as int).toList();
  return bufferInt;
}

class Documents {
  final String idDoc;
  final String nomFichier;
  final String extensionFichier;
  final List<int> dataDocument;
  final String idUser;

  Documents(
      {required this.idDoc,
      required this.nomFichier,
      required this.extensionFichier,
      required this.dataDocument,
      required this.idUser});

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      idDoc: json["_id"],
      nomFichier: json['nom_fichier'],
      extensionFichier: json['extension'],
      dataDocument: transformListBin(json['data_document']['data']),
      idUser: json['idUser'],
    );
  }

  static List<Documents> fromJsonList(dynamic jsonList) {
    final documentsList = <Documents>[];

    if (jsonList["result"] == null) return documentsList;

    if (jsonList["result"] is List<dynamic>) {
      for (final json in jsonList["result"]) {
        documentsList.add(
          Documents.fromJson(json),
        );
      }
    }

    return documentsList;
  }
}
