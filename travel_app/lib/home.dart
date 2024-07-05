import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.name});

  final String name;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;

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
      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 207, 207, 207),
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

  Widget WelcomeTextWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 0, 10),
      child: Text(
        'Welcome, ${widget.name}!',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget WelcomeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [DateWidget(), WelcomeTextWidget()],
    );
  }

  Widget SearchBarWidget() {
    return Center(
      child: Container(
        width: 350,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 240, 240), // Background color
          borderRadius: BorderRadius.circular(25), // Rounded corners
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
              child: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            Container(
              width: 300,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search for a location or search by image',
                    hintStyle: TextStyle(
                        color: Colors.grey, // Set the hint text color
                        fontWeight: FontWeight.w300,
                        fontSize: 13),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SuggestedLocationsWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text('Suggested locations'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SuggestedLocationWidget(),
                  SuggestedLocationWidget(),
                  SuggestedLocationWidget(),
                  SuggestedLocationWidget(),
                  SuggestedLocationWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SuggestedLocationWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Container(
        width: 180,
        height: 120,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 240, 240), // Background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
      ),
    );
  }

  Widget UpcomingTripsWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 0, 10),
            child: Text('Upcoming Trips'),
          ),
          Center(
            child: Container(
              width: 340,
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240), // Background color
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeWidget(),
          SearchBarWidget(),
          SuggestedLocationsWidget(),
          UpcomingTripsWidget()
        ],
      ),
    );
  }
}
