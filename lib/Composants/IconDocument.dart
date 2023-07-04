import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconDocument extends StatelessWidget {
  final IconData faIc;

  IconDocument(this.faIc);

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      faIc,
      color: Colors.white,
      size: 60,
    );
  }
}
