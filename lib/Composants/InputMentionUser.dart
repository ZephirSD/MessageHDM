import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter/material.dart';

class InputMentionUser extends StatefulWidget {
  // final Key _mentionsKey;
  final String trigger;
  final String domaineServer;
  final List<Map<String, dynamic>> listUserString;
  final void Function(String) onListMention;
  final SuggestionPosition position;
  final String labelInput;
  final String? optionTexte;
  InputMentionUser(
    this.domaineServer,
    this.listUserString,
    this.onListMention, {
    this.trigger = "@",
    this.position = SuggestionPosition.Top,
    this.labelInput = "Ajouter des invités avec @",
    this.optionTexte = null,
  });

  @override
  State<InputMentionUser> createState() => _InputMentionUserState();
}

class _InputMentionUserState extends State<InputMentionUser> {
  String valueTexte = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 2)),
      child: FlutterMentions(
        defaultText: widget.optionTexte,
        style: TextStyle(color: Colors.white),
        // key: widget._mentionsKey,
        decoration: InputDecoration(
          fillColor: Colors.white,
          icon: Icon(Icons.people),
          iconColor: Colors.white,
          hintText: widget.labelInput,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        onChanged: (value) {
          setState(() {
            valueTexte = value;
            print(valueTexte);
          });
          if (value.isNotEmpty && value[0] == '@') {
            widget.onListMention(valueTexte);
          } else if (widget.optionTexte != null) {
            widget.onListMention(widget.optionTexte!);
          }
        },
        suggestionPosition: widget.position,
        maxLines: 5,
        minLines: 1,
        mentions: [
          Mention(
            trigger: widget.trigger,
            style: TextStyle(color: Colors.white),
            data: widget.listUserString,
            matchAll: true,
            suggestionBuilder: (data) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      children: <Widget>[
                        widget.listUserString.isEmpty
                            ? const Text("")
                            : Text('@${data['display']}'),
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
