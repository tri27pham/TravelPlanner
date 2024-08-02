import 'package:flutter/material.dart';
import 'package:travel_app/app.dart';
import '../firebase/auth_services.dart';
import '../models/AppState.dart';
import '../models/account.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> logIn(BuildContext context) async {
    if (emailController.text.isEmpty) {
      _showDialog(context, "Empty email", "Please enter an email address");
    } else if (passwordController.text.isEmpty) {
      _showDialog(context, "Empty password", "Please enter a password");
    } else {
      await logInAccount(context);
    }
  }

  Future<void> logInAccount(BuildContext context) async {
    final user = await _authService.singInWithEmailAndPassword(
        emailController.text, passwordController.text);

    if (user != null) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.updateAccount(
        CurrentAccount(
          email: user.email ?? "Unknown Email",
        ),
      );
      print(user.email);
      Navigator.pushReplacementNamed(context, '/welcome');
    } else {
      _showDialog(context, "Login Failed", "Invalid email or password");
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
    passwordController.dispose();
    super.dispose();
  }
}
