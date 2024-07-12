import 'package:flutter/material.dart';
import 'welcome.dart';
import 'auth/login.dart';
import 'auth/createAccount.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateAccountPage(),
      // home: WelcomePage(),
      theme: new ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)),
    );
  }
}
