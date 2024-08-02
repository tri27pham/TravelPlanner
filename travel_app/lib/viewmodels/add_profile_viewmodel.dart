import 'package:flutter/material.dart';
import 'package:travel_app/firebase/db_services.dart';
import 'package:travel_app/models/profile.dart';
import 'package:travel_app/models/AppState.dart';
import 'package:provider/provider.dart';

class AddProfileViewModel extends ChangeNotifier {
  AddProfileViewModel() {
    profileNameController.addListener(onModify);
  }

  final DbService db_service = DbService();

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

  Future<void> addProfile(BuildContext context) async {
    if (profileNameController.text.isEmpty) {
      _showDialog(context, "Empty name", "Please enter a name");
    } else {
      await addProfileToDb(context, profileNameController.text);
    }
  }

  Future<void> addProfileToDb(BuildContext context, name) async {
    await db_service.addProfile(context, name);
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateProfile(
      CurrentProfile(
        name: name,
      ),
    );
    Navigator.pushReplacementNamed(context, '/home');
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
