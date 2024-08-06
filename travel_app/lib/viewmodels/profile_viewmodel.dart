import 'package:flutter/material.dart';
import '../models/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  Profile profile;

  ProfileViewModel({
    String? pid,
    String? name,
    DateTime? dob,
    Color? color,
  }) : profile = Profile(
          pid: pid ?? '',
          name: name ?? "Default Name",
          dob: dob ??
              DateTime(2000, 1,
                  1), // Default birthday to January 1, 2000 if not provided
          color: color ?? Colors.blue,
        );

  DateTime get selectedDate => profile.dob;

  set selectedDate(DateTime date) {
    profile.dob = date;
    notifyListeners();
  }

  String get name => profile.name;

  set name(String newName) {
    profile.name = newName;
    notifyListeners();
  }

  Color get color => profile.color;

  set color(Color newColor) {
    profile.color = newColor;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: profile.dob,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      selectedDate = dateTime;
    }
  }
}
