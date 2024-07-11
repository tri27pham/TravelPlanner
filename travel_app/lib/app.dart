import 'package:flutter/material.dart';
import 'home.dart';
import 'route.dart';
import 'dreamlist.dart';
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
  ];

  void showCustomModalBottomSheet(BuildContext context) {
    Widget LogOutButton() {
      return Container(
        child: ElevatedButton(
          onPressed: () {},
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text('Logout'),
              ),
              Icon(Icons.logout_rounded, size: 20)
            ],
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
        ),
      );
    }

    Widget SwitchProfileButton() {
      return Container(
        child: ElevatedButton(
          onPressed: () {},
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text('Switch profile'),
              ),
              Icon(Icons.people_outline_outlined, size: 20)
            ],
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey, foregroundColor: Colors.white),
        ),
      );
    }

    Widget ProfileInfoWidget() {
      return Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text('Edit picture'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          foregroundColor: Colors.grey[700])),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        children: [
                          Text('Name'),
                          Expanded(
                            child: TextFormField(),
                          ),
                        ],
                      )),
                ],
              )));
    }

    Widget ProfileTitle() {
      return Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 0, 5),
        child: Text(
          'Profile',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
        ),
      );
    }

    Widget ProfileButtonBar() {
      return Padding(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [LogOutButton(), SwitchProfileButton()],
          ));
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileTitle(),
              ProfileInfoWidget(),
              ProfileButtonBar(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
              if (index == 3) {
                // Show modal bottom sheet for the profile tab
                showCustomModalBottomSheet(context);
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
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
