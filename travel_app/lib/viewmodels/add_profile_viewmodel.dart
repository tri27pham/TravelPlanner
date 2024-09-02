import 'package:flutter/material.dart';
import 'package:travel_app/firebase/db_services.dart';
import 'package:travel_app/models/profile_model.dart';
import 'package:travel_app/models/AppState.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import '../models/profile_model.dart';
import 'package:uuid/uuid.dart';

class AddProfileViewModel extends ChangeNotifier {
  AddProfileViewModel() {
    profileNameController.addListener(onModify);
  }

  Color _selectedColor = Colors.orange;
  DateTime _dateOfBirth = DateTime.now();

  final DbService db_service = DbService();

  final TextEditingController profileNameController = TextEditingController();

  List<dynamic> profiles = [];

  bool validProfileDetails = false;

  final uuid = Uuid();

  void onModify() {
    if (profileNameController.text.isNotEmpty) {
      validProfileDetails = true;
    } else {
      validProfileDetails = false;
    }
    notifyListeners();
  }

  set selectedColor(Color color) {
    if (_selectedColor != color) {
      _selectedColor = color;
      notifyListeners();
    }
  }

  set dateOfBirth(DateTime DoB) {
    _dateOfBirth = DoB;
  }

  String getDoBAsString() {
    return DateFormat('dd/MM/yy').format(_dateOfBirth);
  }

  DateTime get dateOfBirth => _dateOfBirth;

  Color get selectedColor => _selectedColor;

  Future<void> addProfile(BuildContext context) async {
    if (profileNameController.text.isEmpty) {
      _showDialog(context, "Empty name", "Please enter a name");
    } else {
      await addProfileToDb(context, profileNameController.text, selectedColor);
    }
  }

  Future<void> addProfileToDb(BuildContext context, name, color) async {
    Profile newProfile =
        Profile(pid: uuid.v4(), name: name, dob: dateOfBirth, color: color);
    await db_service.addProfile(context, newProfile);
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateProfile(newProfile);
    Navigator.pushReplacementNamed(context, '/app');
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
