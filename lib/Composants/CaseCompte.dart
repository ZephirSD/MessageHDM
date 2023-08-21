import 'package:flutter/material.dart';
import 'package:messagehdm/Ressources/couleurs.dart';

class CaseCompte extends StatelessWidget {
  final String texte;
  final Widget? redirection;
  final Function funSupp;
  CaseCompte(this.texte, {this.redirection = null, this.funSupp = _test});

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
                color: CouleursPrefs.bleuCaseBleu,
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
                  redirection != null
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                redirection!,
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : showDialog<String>(
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
                                  funSupp();
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
                        );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        texte,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        child: Align(
                          alignment: AlignmentDirectional(0.9, 0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            // color: Color(0xFF95A1AC),
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
