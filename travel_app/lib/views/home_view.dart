import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../models/AppState.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeWidget(name: appState.profile!.name),
          SearchBarWidget(),
          SuggestedLocationsWidget(),
          UpcomingTripsWidget(),
        ],
      ),
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DateWidget(),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 0, 10),
          child: Text(
            'Welcome, $name!',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class DateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 207, 207, 207),
          ),
          children: [
            TextSpan(text: homeViewModel.getFormattedDate()),
          ],
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuggestedLocationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class SuggestedLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class UpcomingTripsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 0, 10),
            child: Text('Suggested routes'),
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
}
