import 'package:flutter/material.dart';
import '../firebase/auth_services.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();

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
    final user = await _authService.createUserWithEmailAndPassword(
        emailController.text, password1Controller.text);
    if (user != null) {
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
