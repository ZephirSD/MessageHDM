import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messagehdm/Pages/DocumentPage.dart';
import 'package:messagehdm/Ressources/couleurs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:session_next/session_next.dart';
import 'IconDocument.dart';

class CaseDocuments extends StatefulWidget {
  final String title;
  final String idDocument;
  final String extension;
  final String idEvent;
  final List<int> binaryImage;
  CaseDocuments(this.title, this.idDocument, this.extension, this.idEvent,
      this.binaryImage);

  @override
  State<CaseDocuments> createState() => _CaseDocumentsState();
}

class _CaseDocumentsState extends State<CaseDocuments> {
  Widget build(BuildContext context) {
    var mimeType = null;
    TextEditingController _modifTitre = TextEditingController();
    Future<String> createFile() async {
      final tempDir = await getTemporaryDirectory();
      File file =
          await File('${tempDir.path}/${widget.title}.${widget.extension}')
              .create();
      mimeType = lookupMimeType(file.path);
      return mimeType.toString();
    }

    Offset _tapPosition = Offset.zero;
    void _getTapPosition(TapDownDetails details) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      setState(() {
        _tapPosition = renderBox.globalToLocal(details.globalPosition);
        print('position: ${_tapPosition}');
      });
    }

    bool _transformText = false;
    final String _rpcUrl =
        Platform.isAndroid ? 'https://10.0.2.2:8000' : 'https://127.0.0.1:8000';
    var session = SessionNext();
    void _showMenuPop(context) async {
      final RenderObject? overlay =
          Overlay.of(context).context.findRenderObject();
      final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(
            0,
            0,
            overlay!.paintBounds.size.width,
            overlay!.paintBounds.size.height,
          ),
        ),
        items: [
          const PopupMenuItem(
            child: Text('Modifier le titre'),
            value: 'modifier',
          ),
          const PopupMenuItem(
            child: Text('Supprimer le document'),
            value: 'supprimer',
          ),
        ],
      );
      switch (result) {
        case 'modifier':
          print('modifier le titre');
          setState(() {
            _transformText = true;
          });
          break;
        case 'supprimer':
          print('supprimer le document');
          var headers = {'Authorization': 'Bearer ${session.get('tokenUser')}'};
          var request = http.Request('DELETE',
              Uri.parse('$_rpcUrl/api/documents/suppDoc/${widget.idDocument}'));

          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            Directory dir = await getTemporaryDirectory();
            File fileCache =
                File('${dir.path}/${widget.title}.${widget.extension}');
            await fileCache.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Le document ${widget.title} a été supprimé'),
              ),
            );
            Timer(Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context as BuildContext,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      DocumentHome(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            });
          } else {
            print(response.reasonPhrase);
          }
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () async {
          final tempDir = await getTemporaryDirectory();
          File file =
              await File('${tempDir.path}/${widget.title}.${widget.extension}');
          print(file.path);
          print(mimeType.toString());
          file.writeAsBytesSync(widget.binaryImage);
          OpenAppFile.open(file.path);
        },
        onTapDown: (details) {
          _getTapPosition(details);
        },
        onLongPress: () {
          print('ok LongPress ${widget.title}');
          _showMenuPop(context);
        },
        child: SizedBox(
          width: 150,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CouleursPrefs.couleurGrisFonce,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder(
                    future: createFile(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<String> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return snapshot.data!.startsWith("image")
                              ? Image.memory(
                                  Uint8List.fromList(widget.binaryImage),
                                  height: 95,
                                )
                              // PDF
                              : snapshot.data!.endsWith("pdf")
                                  ? IconDocument(FontAwesomeIcons.filePdf)
                                  // Audio
                                  : snapshot.data!.startsWith("audio")
                                      ? IconDocument(FontAwesomeIcons.fileAudio)
                                      // Video
                                      : snapshot.data!.startsWith("video")
                                          ? IconDocument(
                                              FontAwesomeIcons.fileVideo)
                                          // ZIP
                                          : snapshot.data!.endsWith("zip")
                                              ? IconDocument(
                                                  FontAwesomeIcons.fileZipper)
                                              // Calendrier
                                              : snapshot.data!
                                                      .endsWith("calendar")
                                                  ? IconDocument(
                                                      FontAwesomeIcons.calendar)
                                                  // Tableur
                                                  : snapshot.data!.contains(
                                                          "spreadsheet")
                                                      ? IconDocument(
                                                          FontAwesomeIcons
                                                              .fileExcel)
                                                      : snapshot.data!
                                                              .contains("excel")
                                                          ? IconDocument(
                                                              FontAwesomeIcons
                                                                  .fileExcel)
                                                          : snapshot.data!
                                                                  .endsWith(
                                                                      "csv")
                                                              ? IconDocument(
                                                                  FontAwesomeIcons
                                                                      .fileCsv)
                                                              // Presentation
                                                              : snapshot.data!
                                                                      .contains(
                                                                          "presentation")
                                                                  ? IconDocument(
                                                                      FontAwesomeIcons
                                                                          .filePowerpoint)
                                                                  : snapshot
                                                                          .data!
                                                                          .endsWith(
                                                                              "powerpoint")
                                                                      ? IconDocument(
                                                                          FontAwesomeIcons
                                                                              .filePowerpoint)
                                                                      // Traitement de texte
                                                                      : snapshot
                                                                              .data!
                                                                              .endsWith("opendocument.text")
                                                                          ? IconDocument(FontAwesomeIcons.fileWord)
                                                                          : snapshot.data!.contains("word")
                                                                              ? IconDocument(FontAwesomeIcons.fileWord)
                                                                              : IconDocument(FontAwesomeIcons.fileCode);
                        } else {
                          return const Text('Aucune donnée');
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 14, 56, 129),
                            color: Color.fromARGB(255, 82, 111, 255),
                          ),
                        );
                      }
                    },
                  ),
                  _transformText
                      ? Column(
                          children: [
                            TextFormField(
                              // initialValue: widget.title,
                              controller: _modifTitre,
                              decoration: InputDecoration(labelText: "Test"),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Terminer"),
                            ),
                          ],
                        )
                      : Text(
                          widget.title,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
