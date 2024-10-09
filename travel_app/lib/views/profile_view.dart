import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileTitle(),
          ProfileInfoWidget(),
          ProfileButtonBar(),
        ],
      ),
    );
  }
}

class ProfileTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 40, 0, 5),
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class ProfileInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: profileViewModel.color,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Edit picture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.grey[700],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      alignment: Alignment.centerRight,
                      width: 80,
                      child: Text('Name'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextFormField(
                        initialValue: profileViewModel.name,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: 'John',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          profileViewModel.name = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      alignment: Alignment.centerRight,
                      width: 80,
                      child: Text('Birthday'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await profileViewModel.selectDate(context);
                        },
                        child: Text(
                          '${profileViewModel.selectedDate.day} - ${profileViewModel.selectedDate.month} - ${profileViewModel.selectedDate.year}',
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: Size(0, 0),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.all(0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LogOutButton(),
          SwitchProfileButton(),
        ],
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text('Logout'),
            ),
            Icon(Icons.logout_rounded, size: 20),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class SwitchProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text('Switch profile'),
            ),
            Icon(Icons.people_outline_outlined, size: 20),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
