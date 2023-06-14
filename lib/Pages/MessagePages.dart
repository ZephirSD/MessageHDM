import 'package:flutter/material.dart';
import 'package:messagehdm/Pages/EvenementAccueil.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessagePage extends StatelessWidget {
  final String titreEvent;
  MessagePage(this.titreEvent);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessageHome(titreEvent),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MessageHome extends StatefulWidget {
  final String titreEvent;
  MessageHome(this.titreEvent);

  @override
  State<MessageHome> createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      EventPageAccueil(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          Text(
            widget.titreEvent,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          // const StreamMessageInput(),
        ],
      ),
    );
  }
}
