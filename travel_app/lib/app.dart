import 'package:flutter/material.dart';
// import 'home.dart';
import '/views/home_view.dart';
import 'views/route_view.dart';
import 'views/dreamlist_view.dart';
import '/views/profile_view.dart';

class App extends StatefulWidget {
  const App({super.key, required this.name});

  final String name;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  void showCustomModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ProfileView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      HomeView(name: widget.name),
      RoutePlanner(),
      BucketList(),
    ];

    return Scaffold(
      extendBody: true,
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: -8,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green[600],
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index == 3) {
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
            selectedIconTheme: IconThemeData(size: 35),
            unselectedIconTheme: IconThemeData(size: 24),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Route',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: 'Bucket List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
