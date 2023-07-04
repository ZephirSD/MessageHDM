import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'IconDocument.dart';

class CaseDocuments extends StatefulWidget {
  final String title;
  final String extension;
  final String idEvent;
  final List<int> binaryImage;
  CaseDocuments(this.title, this.extension, this.idEvent, this.binaryImage);

  @override
  State<CaseDocuments> createState() => _CaseDocumentsState();
}

class _CaseDocumentsState extends State<CaseDocuments> {
  Widget build(BuildContext context) {
    var mimeType = null;
    Future<String> createFile() async {
      final tempDir = await getTemporaryDirectory();
      File file =
          await File('${tempDir.path}/${widget.title}.${widget.extension}')
              .create();
      mimeType = lookupMimeType(file.path);
      return mimeType.toString();
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
        child: SizedBox(
          width: 150,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.fromARGB(107, 52, 52, 188),
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
                                                                      // Treitement de texte
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
                        return Text('State: ${snapshot.connectionState}');
                      }
                    },
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
