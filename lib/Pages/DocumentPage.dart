import 'package:flutter/material.dart';

class DocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DocumentHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DocumentHome extends StatefulWidget {
  @override
  State<DocumentHome> createState() => _DocumentHomeState();
}

class _DocumentHomeState extends State<DocumentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
          child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Align(
              alignment: AlignmentDirectional(-0.65, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Text(
                  'Document',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
              child: TextFormField(
                //controller: _model.textController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Document à rechercher',
                  hintStyle: const TextStyle(
                    fontFamily: 'Lexend Deca',
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  filled: true,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                //style: FlutterFlowTheme.of(context).bodyMedium,
                // validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
            Column(
              children: [
                const Align(
                  alignment: AlignmentDirectional(-0.65, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Documents récents',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 200,
                    color: Colors.deepPurple,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                const Align(
                  alignment: AlignmentDirectional(-0.65, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: Text(
                      'Liste des documents',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 200,
                    color: Colors.deepPurple,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
