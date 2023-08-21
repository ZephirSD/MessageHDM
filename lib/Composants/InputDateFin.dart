import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class InputDateFin extends StatefulWidget {
  final TextEditingController _dateFin;
  DateTime? _selectedDate;
  final String label;

  InputDateFin(
    this._dateFin,
    this._selectedDate,
    this.label,
  );

  @override
  State<InputDateFin> createState() => _InputDateFinState();
}

class _InputDateFinState extends State<InputDateFin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: widget._dateFin,
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
          DateTime? dateRecupFin = await showDatePicker(
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
            widget._selectedDate = dateRecupFin;
            if (widget._selectedDate != null) {
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(widget._selectedDate!);
              setState(() {
                widget._dateFin.text = formattedDate;
              });
            }
          });
        },
      ),
    );
  }
}
