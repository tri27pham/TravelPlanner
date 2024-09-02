import 'package:flutter/material.dart';
import 'package:travel_app/models/current_profile.dart';
import '../firebase/auth_services.dart';
import '../firebase/db_services.dart';
import '../models/account.dart';
import 'package:travel_app/models/AppState.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import '../models/profile_model.dart';
import 'package:uuid/uuid.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DbService _dbService = DbService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final uuid = Uuid();

  Future<void> signUp(BuildContext context) async {
    if (emailController.text.isNotEmpty &&
        password1Controller.text.isNotEmpty &&
        password2Controller.text.isNotEmpty &&
        password1Controller.text == password2Controller.text) {
      await createAccount(context);
    } else if (emailController.text.isEmpty) {
      _showDialog(context, "Empty email", "Please enter an email address");
    } else if (password1Controller.text.isEmpty ||
        password2Controller.text.isEmpty ||
        password1Controller.text != password2Controller.text) {
      _showDialog(context, "Mismatching passwords",
          "Please ensure your passwords match");
    }
  }

  Future<void> createAccount(BuildContext context) async {
    final _appState = Provider.of<AppState>(context, listen: false);

    final user = await _authService.createUserWithEmailAndPassword(
        emailController.text, password1Controller.text);
    if (user != null) {
      _appState.updateAccount(
        CurrentAccount(
          uid: user.uid,
          email: user.email ?? "Unknown Email",
        ),
      );
      Profile newProfile = Profile(
          pid: uuid.v4(),
          name: _appState.account!.email,
          dob: DateTime.now(),
          color: Colors.green);
      await _dbService.createAccount(context);
      await _dbService.addProfile(context, newProfile);
      _appState.updateProfile(newProfile);
      Navigator.pushReplacementNamed(context, '/welcome');
    } else {
      _showDialog(context, "Account Creation Failed",
          "Unable to create account. Please try again.");
    }
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

  @override
  void dispose() {
    emailController.dispose();
    password1Controller.dispose();
    password2Controller.dispose();
    super.dispose();
  }
}
