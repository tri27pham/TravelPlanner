import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/date_model.dart';

class HomeViewModel extends ChangeNotifier {
  DateModel _dateModel = DateModel(DateTime.now());

  String getFormattedDate() {
    DateTime now = _dateModel.date;
    String day = DateFormat('d').format(now);
    String daySuffix = _toSuperscript(_dateModel.getDaySuffix());

    return '${DateFormat('EEEE ').format(now)}$day$daySuffix${DateFormat(' MMMM yyyy').format(now)}';
  }

  String _toSuperscript(String input) {
    final Map<String, String> unicodeSuperscript = {
      '1': '\u00B9',
      '2': '\u00B2',
      '3': '\u00B3',
      't': '\u1d57',
      'h': '\u02b0',
      's': '\u02e2',
      'n': '\u207f',
      'r': '\u02b3',
      'd': '\u1d48',
    };

    return input
        .split('')
        .map((char) => unicodeSuperscript[char] ?? char)
        .join('');
  }
}
