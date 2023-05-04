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
  final _formInscr = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(child: Container()),
              Form(
                key: _formInscr,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pseudo',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Telephone',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mot de passe',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Inscrire'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
