import 'package:flutter/material.dart';

class AddProfileViewModel extends ChangeNotifier {
  AddProfileViewModel() {
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
}
