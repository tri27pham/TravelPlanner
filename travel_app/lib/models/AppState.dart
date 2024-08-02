import 'package:flutter/material.dart';
import 'account.dart';
import 'profile.dart';

class AppState with ChangeNotifier {
  CurrentAccount? _account;
  CurrentProfile? _profile;

  CurrentAccount? get account => _account;
  CurrentProfile? get profile => _profile;

  void updateAccount(CurrentAccount account) {
    _account = account;
    notifyListeners();
  }

  void updateProfile(CurrentProfile profile) {
    _profile = profile;
    notifyListeners();
  }
}
