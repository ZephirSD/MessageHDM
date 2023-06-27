import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class InputDateDebut extends StatefulWidget {
  final TextEditingController _dateDebut;
  DateTime? _selectedDate;
  final String label;

  InputDateDebut(
    this._dateDebut,
    this._selectedDate,
    this.label,
  );

  @override
  State<InputDateDebut> createState() => _InputDateDebutState();
}

class _InputDateDebutState extends State<InputDateDebut> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: widget._dateDebut,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          iconColor: Colors.white,
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          hintText: widget._selectedDate == null
              ? ''
              : DateFormat('dd/MM/yyyy').format(widget._selectedDate!),
          hintStyle: TextStyle(color: Colors.white, fontSize: 15),
        ),
        readOnly: true,
        style: TextStyle(color: Colors.white, fontSize: 15),
        onTap: () async {
          DateTime? dateRecupDeb = await showDatePicker(
            context: context,
            locale: const Locale("fr", "FR"),
            initialDate: widget._selectedDate != null
                ? DateTime(widget._selectedDate!.year,
                    widget._selectedDate!.month, widget._selectedDate!.day)
                : DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2200),
          );
          setState(() {
            widget._selectedDate = dateRecupDeb;
          });
          // if (widget._selectedDate != null) {
          //   // print(_selectedDate.toString());
          //   String formattedDate =
          //       DateFormat('dd/MM/yyyy').format(widget._selectedDate!);
          //   // print(formattedDate);
          //   setState(() {
          //     widget._dateFin.text = formattedDate;
          //   });
          // }
        },
      ),
    );
  }
}
