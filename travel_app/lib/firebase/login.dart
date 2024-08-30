// import 'dart:ui';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'createAccount.dart';
// import 'auth_services.dart';
// import '../views/welcome_page_view.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   final _auth = AuthService();

//   logIn() {
//     if (_emailController.text.isEmpty) {
//       _showEmptyEmailDialog(context);
//     } else if (_passwordController.text.isEmpty) {
//       _showEmptyPasswordDialog(context);
//     } else {
//       logInAccount();
//     }
//   }

//   logInAccount() async {
//     final user = await _auth.singInWithEmailAndPassword(
//         _emailController.text, _passwordController.text);
//     if (user != null) {
//       log('USER LOGIN SUCCESS');
//       goToWelcomePage(context);
//     } else {
//       log('USER LOGIN FAILED');
//     }
//   }

//   goToWelcomePage(BuildContext content) => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => WelcomePage()),
//       );

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

//   void _showEmptyPasswordDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Empty password"),
//           content: Text("Please enter a password"),
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
//     _passwordController.dispose();
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
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter password',
//                       border: InputBorder.none, // Remove the border
//                     ),
//                   )),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               child: ElevatedButton(
//                 onPressed: () {
//                   logIn();
//                 },
//                 child: Text('LOG IN'),
//                 style: ElevatedButton.styleFrom(
//                     primary: Colors.green, foregroundColor: Colors.white),
//               ),
//             ),
//             Container(
//               height: 40,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => CreateAccountPage()),
//                   );
//                 },
//                 child: Text(
//                   "Don't have an account? Create account",
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
