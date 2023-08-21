class Notifications {
  final String idNotif;
  final String evenements;
  final String type_notif;
  final String message_notif;
  final String destin_notif;

  Notifications(
      {required this.idNotif,
      required this.evenements,
      required this.type_notif,
      required this.message_notif,
      required this.destin_notif});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      idNotif: json["_id"],
      evenements: json['evenements'],
      type_notif: json['type_notif'],
      message_notif: json['message_notif'],
      destin_notif: json['destin_notif'],
    );
  }

  static List<Notifications> fromJsonList(dynamic jsonList) {
    final notificationsList = <Notifications>[];
    if (jsonList["result"] == null) return notificationsList;

    if (jsonList["result"] is List<dynamic>) {
      for (final json in jsonList["result"]) {
        notificationsList.add(
          Notifications.fromJson(json),
        );
      }
    }

    return notificationsList;
  }
}
