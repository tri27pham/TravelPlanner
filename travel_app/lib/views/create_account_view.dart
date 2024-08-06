import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/create_account_viewmodel.dart';
import 'login_view.dart';

class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAccountViewModel(),
      child: Consumer<CreateAccountViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'WANDER',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 10.0),
                    ),
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
                        controller: viewModel.emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
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
                        controller: viewModel.password1Controller,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
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
                        controller: viewModel.password2Controller,
                        decoration: InputDecoration(
                          hintText: 'Re-enter password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.signUp(context);
                      },
                      child: Text('CREATE ACCOUNT'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green, foregroundColor: Colors.white),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          foregroundColor: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
