import 'dart:ui';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Define any state variables here
  int _counter = 0;

  // Define any methods to modify the state here
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      border: InputBorder.none, // Remove the border
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      border: InputBorder.none, // Remove the border
                    ),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('LOG IN'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green, foregroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
