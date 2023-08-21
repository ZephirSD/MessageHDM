List<int> transformListBin(var value) {
  List<dynamic> bufferDynamic = value;
  List<int> bufferInt = bufferDynamic.map((e) => e as int).toList();
  return bufferInt;
}

class Messages {
  final String auteur;
  final String? texte;
  final String evenement;
  final List<int>? document;
  final String dateEnvoi;

  Messages({
    required this.auteur,
    required this.texte,
    required this.evenement,
    required this.document,
    required this.dateEnvoi,
  });
  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      auteur: json["auteur"],
      texte: json["texte"] ?? "",
      evenement: json["evenement"],
      document: json["document"].isUndefined
          ? transformListBin(json["document"]['data'])
          : null,
      dateEnvoi: json["date_envoi"],
    );
  }
  static List<Messages> fromJsonList(dynamic jsonList) {
    final messagesList = <Messages>[];
    messagesList.clear();
    if (jsonList["result"] == null) return messagesList;
    if (jsonList["result"] is List<dynamic>) {
      for (final json in jsonList["result"]) {
        messagesList.add(
          Messages.fromJson(json),
        );
      }
    }
    return messagesList;
  }
}
