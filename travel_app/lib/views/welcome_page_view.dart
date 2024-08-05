import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../viewmodels/welcome_viewmodel.dart';
import '../models/profile_model.dart';
import '../models/AppState.dart';
import '../models/current_profile.dart';
import 'addProfile_view.dart';
import 'dart:developer';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void showAddProfile(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddProfile(),
        );
      },
    );
  }

  Widget buildDateWidget(BuildContext context) {
    final viewModel = Provider.of<WelcomeViewModel>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 181, 181, 181),
          ),
          children: [
            TextSpan(text: viewModel.getFormattedDate()),
          ],
        ),
      ),
    );
  }

  Widget buildProfileWidget(BuildContext context, Profile profile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.updateProfile(CurrentProfile(name: profile.name));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => App()),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(100, 100),
              primary: profile.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Text(''),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              profile.name,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 181, 181, 181),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addProfileButton(WelcomeViewModel viewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showAddProfile(context);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              fixedSize: Size(100, 100),
              primary: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: BorderSide(
                  color: Colors.grey, // Set the border color
                  width: 2, // Set the border width
                ),
              ),
            ),
            child: Icon(
              Icons.add_circle_outline_sharp,
              color: Colors.grey,
              size: 50,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              'Add Profile',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 181, 181, 181),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfilesWidget(BuildContext context) {
    final viewModel = Provider.of<WelcomeViewModel>(context);

    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          ...viewModel.profiles
              .map((profile) => buildProfileWidget(context, profile))
              .toList(),
        ],
      ),
    );
  }

  Widget buildWelcomeTextWidget() {
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
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(),
      child: Consumer<WelcomeViewModel>(
        builder: (context, viewModel, child) {
          return FutureBuilder<void>(
            future: viewModel
                .loadProfiles(context), // Wait for this future to complete
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading profiles'), // Show error message
                );
              } else {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDateWidget(context),
                        buildWelcomeTextWidget(),
                        buildProfilesWidget(context),
                        addProfileButton(viewModel, context),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
