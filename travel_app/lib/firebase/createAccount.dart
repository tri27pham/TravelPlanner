// import 'dart:ui';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import '../viewmodels/login_viewmodel.dart';
// import 'auth_services.dart';
// import '../views/welcome_page_view.dart';

// class CreateAccountPage extends StatefulWidget {
//   @override
//   _CreateAccountPageState createState() => _CreateAccountPageState();
// }

// class _CreateAccountPageState extends State<CreateAccountPage> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _password1Controller = TextEditingController();
//   TextEditingController _password2Controller = TextEditingController();

//   final _auth = AuthService();

//   goToWelcomePage(BuildContext content) => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => WelcomePage()),
//       );

//   signUp() {
//     if (_emailController.text.isNotEmpty &&
//         _password1Controller.text.isNotEmpty &&
//         _password2Controller.text.isNotEmpty &&
//         _password1Controller.text == _password2Controller.text) {
//       createAccount();
//     } else if (_emailController.text.isEmpty) {
//       _showEmptyEmailDialog(context);
//     } else if (_password1Controller.text.isEmpty ||
//         _password2Controller.text.isEmpty ||
//         _password1Controller.text != _password2Controller.text) {
//       _showMismatchingPasswordslDialog(context);
//     }
//   }

//   createAccount() async {
//     final user = await _auth.createUserWithEmailAndPassword(
//         _emailController.text, _password1Controller.text);
//     if (user != null) {
//       log('USER CREATION SUCCESS');
//       goToWelcomePage(context);
//     } else {
//       log('USER CREATION FAILED');
//     }
//   }

//   void _showEmptyEmailDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Empty email"),
//           content: Text("Please enter an email address"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showMismatchingPasswordslDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Mismatching passwords"),
//           content: Text("Please ensure your passwords match"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _emailController.dispose();
//     _password1Controller.dispose();
//     _password2Controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Text(
//                 'WANDER',
//                 style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 10.0),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//               child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: 50,
//                   padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.all(Radius.circular(25))),
//                   child: TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter email',
//                       border: InputBorder.none, // Remove the border
//                     ),
//                   )),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//               child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: 50,
//                   padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.all(Radius.circular(25))),
//                   child: TextFormField(
//                     controller: _password1Controller,
//                     decoration: InputDecoration(
//                       hintText: 'Enter password',
//                       border: InputBorder.none, // Remove the border
//                     ),
//                   )),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//               child: Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: 50,
//                   padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.all(Radius.circular(25))),
//                   child: TextFormField(
//                     controller: _password2Controller,
//                     decoration: InputDecoration(
//                       hintText: 'Re-enter password',
//                       border: InputBorder.none, // Remove the border
//                     ),
//                   )),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               child: ElevatedButton(
//                 onPressed: () {
//                   signUp();
//                 },
//                 child: Text('CREATE ACCOUNT'),
//                 style: ElevatedButton.styleFrom(
//                     primary: Colors.green, foregroundColor: Colors.white),
//               ),
//             ),
//             Container(
//               height: 40,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => LoginPage()),
//                   // );
//                 },
//                 child: Text(
//                   'Already have an account? Sign in',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     decorationColor:
//                         Colors.grey, // Optional: Color of the underline
//                     decorationStyle: TextDecorationStyle.solid,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                     primary: Colors.transparent,
//                     elevation: 0,
//                     foregroundColor: Colors.grey),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
