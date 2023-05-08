import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  final TextEditingController _dateFin;
  DateTime? _selectedDate;
  final String label;

  InputDate(
    this._dateFin,
    this._selectedDate,
    this.label,
  );

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._dateFin,
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today), labelText: widget.label),
      readOnly: true,
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

        if (widget._selectedDate != null) {
          // print(_selectedDate.toString());
          String formattedDate =
              DateFormat('dd/MM/yyyy').format(widget._selectedDate!);
          // print(formattedDate);
          setState(() {
            widget._dateFin.text = formattedDate;
          });
        }
      },
    );
  }
}
