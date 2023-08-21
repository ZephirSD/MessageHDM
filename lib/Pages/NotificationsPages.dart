import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:messagehdm/Composants/NotificationPush.dart';
import 'package:messagehdm/Composants/Notifications/notifications_class.dart';
// import 'package:messagehdm/Composants/Fonctions/ThemeApplication.dart';
import 'package:messagehdm/main.dart';
import 'package:session_next/session_next.dart';
import '../Composants/NotificationCase.dart';
import '../Ressources/couleurs.dart';
// import 'package:messagehdm/Composants/NotificationPush.dart';

class NotificationPages extends StatelessWidget {
  const NotificationPages({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationContainer extends StatefulWidget {
  const NotificationContainer({super.key});

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
var session = SessionNext();

class _NotificationContainerState extends State<NotificationContainer> {
  bool switchValueNotif = false;

  void initState() {
    // TODO: implement initState
    NotificationsPushMessage.initialize(flutterLocalNotificationsPlugin, true);
    super.initState();
  }

  Future<List<Notifications>> fetchNotifications() async {
    var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
    var url =
        Uri.parse('$_rpcUrl/api/notifications/${session.get('pseudoUser')}');
    var request = http.Request('GET', url);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var streamReponse = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return Notifications.fromJsonList(json.decode(streamReponse.body));
    } else {
      throw Exception('Request Failed.');
    }
  }

  Stream<List<Notifications>> getNotifications(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CouleursPrefs.couleurPrinc,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: StreamBuilder(
          stream: getNotifications(Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.data != null) {
              final notifications = snapshot.data!;
              if (snapshot.data!.length > 0) {
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notific = notifications[index];
                    return NotificationCase(
                      notific.message_notif,
                      "08/08/2023",
                      notific.evenements,
                      notific.idNotif,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'Vous n\'avez pas de notifications',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }
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
          },
        ),
      ),
    );
  }
}
