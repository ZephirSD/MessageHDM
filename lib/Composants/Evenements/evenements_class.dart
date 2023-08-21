class Evenements {
  final String idEvent;
  final String nomEvent;
  final String dateDebut;
  final String dateFin;
  final String modeEvent;
  final String createEvent;

  Evenements({
    required this.idEvent,
    required this.nomEvent,
    required this.dateDebut,
    required this.dateFin,
    required this.modeEvent,
    required this.createEvent,
  });

  factory Evenements.fromJson(Map<String, dynamic> json) {
    return Evenements(
      idEvent: json["_id"],
      nomEvent: json['nom_event'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      modeEvent: json['mode_event'],
      createEvent: json['create_event'],
    );
  }

  static List<Evenements> fromJsonList(dynamic jsonList) {
    final evenementsList = <Evenements>[];
    if (jsonList["result"] == null) return evenementsList;

    if (jsonList["result"] is List<dynamic>) {
      for (final json in jsonList["result"]) {
        evenementsList.add(
          Evenements.fromJson(json),
        );
      }
    }

    return evenementsList;
  }
}
