import 'package:flutter/material.dart';
import 'package:messagehdm/Ressources/couleurs.dart';

// ignore: must_be_immutable
class CaseCompte extends StatefulWidget {
  final String texte;
  final Widget? redirection;
  final Function funSupp;
  final bool boolPage;
  final bool boolPopUp;
  final bool toggle;
  bool activeToggle;
  CaseCompte(this.texte,
      {this.redirection = null,
      this.boolPage = true,
      this.boolPopUp = false,
      this.toggle = false,
      this.activeToggle = true,
      this.funSupp = _test});

  @override
  State<CaseCompte> createState() => _CaseCompteState();
}

class _CaseCompteState extends State<CaseCompte> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 60,
              decoration: BoxDecoration(
                color: CouleursPrefs.couleurGrisFonce,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 1),
                  )
                ],
                shape: BoxShape.rectangle,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  widget.boolPage
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                widget.redirection!,
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : widget.boolPopUp
                          ? showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                // backgroundColor: Colors.deepPurple,
                                content: const Text(
                                  'Voulez vraiment supprimer votre compte ?',
                                  style: TextStyle(fontSize: 17),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: const Text(
                                      'Non',
                                      style: TextStyle(
                                        color: CouleursPrefs.couleurRose,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      widget.funSupp();
                                    },
                                    child: const Text(
                                      'Oui',
                                      style: TextStyle(
                                        color: CouleursPrefs.couleurRose,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.texte,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        child: Align(
                          alignment: AlignmentDirectional(0.9, 0),
                          child: widget.toggle
                              ? Switch(
                                  value: widget.activeToggle,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.activeToggle = newValue;
                                    });
                                  },
                                )
                              : Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 18,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_test() {}
