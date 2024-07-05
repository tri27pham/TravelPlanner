// // import 'package:flutter/material.dart';
// // import 'home.dart';
// // import 'route.dart';
// // import 'bucketlist.dart';
// // import 'profile.dart';

// // class App extends StatefulWidget {
// //   const App({super.key});

// //   @override
// //   State<App> createState() => _AppState();
// // }

// // class _AppState extends State<App> {
// //   int _currentIndex = 0;

// //   final List<Widget> _tabs = [
// //     HomePage(name: 'John'),
// //     RoutePlanner(),
// //     BucketList(),
// //     Profile()
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _tabs[_currentIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //           type: BottomNavigationBarType.fixed,
// //           onTap: (index) {
// //             setState(() {
// //               _currentIndex = index;
// //             });
// //           },
// //           currentIndex: _currentIndex,
// //           showUnselectedLabels: false,
// //           selectedItemColor: Colors.green[600],
// //           items: const [
// //             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //             BottomNavigationBarItem(
// //                 icon: Icon(Icons.map_outlined), label: 'Route'),
// //             BottomNavigationBarItem(
// //                 icon: Icon(Icons.list), label: 'Bucket List'),
// //             BottomNavigationBarItem(
// //                 icon: Icon(Icons.person_2_outlined), label: 'Profile')
// //           ]),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'route.dart';
// import 'bucketlist.dart';
// import 'profile.dart';

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   int _currentIndex = 0;

//   final List<Widget> _tabs = [
//     HomePage(name: 'John'),
//     RoutePlanner(),
//     BucketList(),
//     Profile()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _tabs[_currentIndex],
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(
//             Radius.circular(35),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               spreadRadius: -6,
//               blurRadius: 1,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(35)),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Colors.white, // Make background transparent
//             selectedItemColor: Colors.green[600], // Change selected item color
//             unselectedItemColor: Colors.grey, // Change unselected item color
//             onTap: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             currentIndex: _currentIndex,
//             showUnselectedLabels: false,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.map_outlined), label: 'Route'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.list), label: 'Bucket List'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.person_2_outlined), label: 'Profile')
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: App(),
//   ));
// }

import 'package:flutter/material.dart';
import 'home.dart';
import 'route.dart';
import 'bucketlist.dart';
import 'profile.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomePage(name: 'John'),
    RoutePlanner(),
    BucketList(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(40)), // Make all corners rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Shadow color
              spreadRadius: -8, // Spread radius
              blurRadius: 2, // Blur radius
              offset: Offset(
                  0, 0), // Shadow position (horizontal and vertical offset)
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(40)), // Make all corners rounded
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white, // Make background transparent
            selectedItemColor: Colors.green[600], // Change selected item color
            unselectedItemColor: Colors.grey, // Change unselected item color
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            selectedIconTheme: IconThemeData(size: 35), // Selected icon size
            unselectedIconTheme:
                IconThemeData(size: 24), // Unselected icon size
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined), label: 'Route'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined), label: 'Bucket List'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined), label: 'Profile')
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: App(),
  ));
}
