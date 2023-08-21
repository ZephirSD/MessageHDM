import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';

functDeconnexion(BuildContext context) async {
  session.removeAll();
  Directory dir = await getTemporaryDirectory();
  dir.deleteSync(recursive: true);
  dir.create();
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => MyApp(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}
