// welcome_view_model.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/profile_model.dart';
import '../firebase/db_services.dart';

class WelcomeViewModel extends ChangeNotifier {
  final DbService db_service = DbService();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Profile> profiles = [];

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

  Future<void> loadProfiles(BuildContext context) async {
    profiles = await db_service.loadProfilesFromDb(context);
  }
}
