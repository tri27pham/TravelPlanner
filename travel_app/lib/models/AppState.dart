import 'package:flutter/material.dart';
import 'account.dart';
import 'current_profile.dart';
import '../models/profile_model.dart';

class AppState with ChangeNotifier {
  CurrentAccount? _account;
  Profile? _profile;

  CurrentAccount? get account => _account;
  Profile? get profile => _profile;

  void updateAccount(CurrentAccount account) {
    _account = account;
    notifyListeners();
  }

  void updateProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  void reset() {
    _account = null;
    _profile = null;
    notifyListeners();
  }
}
