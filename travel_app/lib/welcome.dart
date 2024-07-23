import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'app.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Map<String, String> unicodeSuperscript = {
    '1': '\u00B9',
    '2': '\u00B2',
    '3': '\u00B3',
    't': '\u1d57',
    'h': '\u02b0',
    's': '\u02e2',
    'n': '\u207f',
    'r': '\u02b3',
    'd': '\u1d48',
  };

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String toSuperscript(String input) {
    return input
        .split('')
        .map((char) => unicodeSuperscript[char] ?? char)
        .join('');
  }

  Widget DateWidget() {
    DateTime now = DateTime.now();
    String day = DateFormat('d').format(now);
    String daySuffix = toSuperscript(getDaySuffix(now.day));

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 181, 181, 181),
          ),
          children: [
            TextSpan(text: DateFormat('EEEE ').format(now)),
            TextSpan(text: day),
            TextSpan(text: daySuffix),
            TextSpan(text: DateFormat(' MMMM yyyy').format(now)),
          ],
        ),
      ),
    );
  }

  Widget ProfileWidget(String name, Color color) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => App(name: '')),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(75, 75),
                primary: color,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(7), // Example of rounded corners
                ),
              ),
              child: Text(''),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 181, 181, 181),
                ),
              ),
            ),
          ],
        ));
  }

  Widget ProfilesWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileWidget('John', Colors.red),
            ProfileWidget('Mary', Colors.blue),
            ProfileWidget('Adam', Colors.amber),
            ProfileWidget('Eve', Colors.deepOrange),
            ProfileWidget('Mum', Colors.pink),
            ProfileWidget('Dad', Colors.deepPurple),
          ],
        ),
      ),
    );
  }

  Widget WelcomeTextWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 20),
      child: Text(
        'Welcome!',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateWidget(),
            WelcomeTextWidget(),
            ProfilesWidget(),
          ],
        ),
      ),
    );
  }
}
