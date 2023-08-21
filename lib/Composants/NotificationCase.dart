import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:session_next/session_next.dart';

final String _rpcUrl =
    Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
var session = SessionNext();

class NotificationCase extends StatefulWidget {
  final String messageNotif;
  final String dateNotif;
  final String eventID;
  final String notifID;

  NotificationCase(
      this.messageNotif, this.dateNotif, this.eventID, this.notifID);

  @override
  State<NotificationCase> createState() => _NotificationCaseState();
}

class _NotificationCaseState extends State<NotificationCase> {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${session.get('tokenUser')}'
  };
  supprimeNotification(String notif) async {
    var request = http.Request(
        'DELETE', Uri.parse('$_rpcUrl/api/notifications/supprNotif/$notif'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {
      print(response.reasonPhrase);
    }
  }

  envoiAcceptation(String event) async {
    var request =
        http.Request('PUT', Uri.parse('$_rpcUrl/api/evenements/invite/$event'));
    request.body = json.encode({"pseudo": session.get('pseudoUser')});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var streamReponse = await http.Response.fromStream(response);
    var jsonMessage = json.decode(streamReponse.body);

    if (response.statusCode == 200) {
      await supprimeNotification(widget.notifID);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonMessage['message']),
        ),
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  refusAcceptation(String event) async {
    var request = http.Request(
        'PUT', Uri.parse('$_rpcUrl/api/evenements/invite-refus/$event'));
    request.body = json.encode({"pseudo": session.get('pseudoUser')});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      await supprimeNotification(widget.notifID);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vous avez refusé l\'évènement'),
        ),
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              envoiAcceptation(widget.eventID);
            },
            backgroundColor: Colors.green,
            icon: Icons.check,
            label: "Accepter",
          ),
          SlidableAction(
            onPressed: (context) {
              refusAcceptation(widget.eventID);
            },
            backgroundColor: Colors.red,
            icon: Icons.close,
            label: "Refuser",
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 224, 224),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  size: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.5),
                      child: Text(
                        widget.messageNotif,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.5),
                      child: Text(
                        widget.dateNotif,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
