// welcome_view_model.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/profile_model.dart';

class WelcomeViewModel extends ChangeNotifier {
  WelcomeViewModel() {
    profileNameController.addListener(onModify);
  }

  final TextEditingController profileNameController = TextEditingController();

  bool validProfileDetails = false;

  void onModify() {
    if (profileNameController.text.isNotEmpty) {
      validProfileDetails = true;
    } else {
      validProfileDetails = false;
    }
    notifyListeners();
  }

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

  List<Profile> profiles = [
    Profile(name: 'John', color: Colors.red, birthday: DateTime(1990, 1, 1)),
    Profile(name: 'Mary', color: Colors.blue, birthday: DateTime(1985, 2, 14)),
    Profile(name: 'Adam', color: Colors.amber, birthday: DateTime(2000, 3, 21)),
    Profile(
        name: 'Eve', color: Colors.deepOrange, birthday: DateTime(1995, 4, 10)),
    // Profile(name: 'Mum', color: Colors.pink, birthday: DateTime(1965, 5, 15)),
    // Profile(
    //     name: 'Dad', color: Colors.deepPurple, birthday: DateTime(1960, 6, 18)),
  ];

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String toSuperscript(String input) {
    return input
        .split('')
        .map((char) => unicodeSuperscript[char] ?? char)
        .join('');
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String day = DateFormat('d').format(now);
    String daySuffix = toSuperscript(getDaySuffix(now.day));
    return "${DateFormat('EEEE ').format(now)}$day$daySuffix${DateFormat(' MMMM yyyy').format(now)}";
  }
}
