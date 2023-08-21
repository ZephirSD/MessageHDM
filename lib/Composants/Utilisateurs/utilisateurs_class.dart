class Utilisateur {
  final String email;
  final String pseudo;
  final String telephone;

  Utilisateur({
    required this.email,
    required this.pseudo,
    required this.telephone,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      email: json["result"]["email"],
      pseudo: json["result"]["pseudo"],
      telephone: json["result"]["telephone"],
    );
  }

  factory Utilisateur.fromAllJson(Map<String, dynamic> json) {
    return Utilisateur(
      email: json["email"],
      pseudo: json["pseudo"],
      telephone: json["telephone"],
    );
  }

  List<Utilisateur> fromJsonList(dynamic jsonList) {
    final utilisateurList = <Utilisateur>[];
    utilisateurList.clear();
    if (jsonList["result"] == null) return utilisateurList;
    if (jsonList["result"] is List<dynamic>) {
      for (final json in jsonList["result"]) {
        utilisateurList.add(
          Utilisateur.fromJson(json),
        );
      }
    }
    return utilisateurList;
  }

  static List<Utilisateur> fromJsonAllList(dynamic jsonList) {
    final utilisateurList = <Utilisateur>[];
    utilisateurList.clear();
    if (jsonList == null) return utilisateurList;
    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        utilisateurList.add(
          Utilisateur.fromAllJson(json),
        );
      }
    }
    return utilisateurList;
  }
}
