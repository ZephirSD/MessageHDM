import 'package:flutter/material.dart';
import 'package:messagehdm/Composants/NavHomeBottom.dart';
import '../Composants/CaseEvent.dart';
import 'NewEvenement.dart';

class EventPageAccueil extends StatelessWidget {
  const EventPageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EventContainerAccueil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EventContainerAccueil extends StatefulWidget {
  const EventContainerAccueil({super.key});

  @override
  State<EventContainerAccueil> createState() => _EventContainerAccueilState();
}

class _EventContainerAccueilState extends State<EventContainerAccueil> {
  int _selectedIndex = 0;
  final List listEvent = [
    "Event1",
    "Event2",
    "Event3",
  ];
  changeSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        bottomNavigationBar: NavHomeBottom(
          _selectedIndex,
          changeSelect: () => changeSelect,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bonjour',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewEventPage(),
                          ),
                        ),
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listEvent.length,
                itemBuilder: (context, index) {
                  return CaseEvent(listEvent[index], index + 1);
                },
              ),
            ),
          ],
        ));
  }
}
