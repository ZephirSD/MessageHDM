import 'package:flutter/material.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InscriptionContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InscriptionContainer extends StatefulWidget {
  const InscriptionContainer({super.key});

  @override
  State<InscriptionContainer> createState() => _InscriptionContainerState();
}

class _InscriptionContainerState extends State<InscriptionContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
