// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../app.dart';
// import '../viewmodels/welcome_viewmodel.dart';
// import '../models/profile_model.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   void showAddProfile(WelcomeViewModel viewModel, BuildContext context) {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: addProfileWidget(viewModel, context),
//         );
//       },
//     );
//   }

//   Widget addProfileWidget(WelcomeViewModel viewModel, BuildContext context) {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         viewModel.profileNameController.addListener(() {
//           setState(() {
//             viewModel.onModify();
//           });
//         });

//         return Container(
//           height: MediaQuery.of(context).size.height * 0.7,
//           width: MediaQuery.of(context).size.width * 0.8,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     elevation: 0,
//                     foregroundColor: Colors.grey[700],
//                     backgroundColor: Colors.transparent,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(7),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: 20),
//                         child: Container(
//                           height: MediaQuery.of(context).size.height * 0.06,
//                           width: MediaQuery.of(context).size.width * 0.6,
//                           child: TextFormField(
//                             controller: viewModel.profileNameController,
//                             decoration: InputDecoration(
//                               labelText: 'Profile Name',
//                               labelStyle: TextStyle(
//                                 fontSize: 15,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 borderSide: BorderSide(color: Colors.grey),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 20),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: viewModel.validProfileDetails
//                         ? () {
//                             // Add your profile add logic here
//                           }
//                         : null,
//                     child: Text('Add Profile'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(150, 40),
//                       elevation: 0,
//                       backgroundColor: viewModel.validProfileDetails
//                           ? Colors.green
//                           : Colors.transparent,
//                       foregroundColor: viewModel.validProfileDetails
//                           ? Colors.white
//                           : Colors.grey[700],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildDateWidget(BuildContext context) {
//     final viewModel = Provider.of<WelcomeViewModel>(context);
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
//       child: RichText(
//         text: TextSpan(
//           style: TextStyle(
//             fontSize: 18,
//             color: Color.fromARGB(255, 181, 181, 181),
//           ),
//           children: [
//             TextSpan(text: viewModel.getFormattedDate()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildProfileWidget(BuildContext context, Profile profile) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//       child: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => App(name: profile.name)),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               fixedSize: Size(100, 100),
//               primary: profile.color,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(7),
//               ),
//             ),
//             child: Text(''),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//             child: Text(
//               profile.name,
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color.fromARGB(255, 181, 181, 181),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget addProfileButton(WelcomeViewModel viewModel, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//       child: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               showAddProfile(viewModel, context);
//             },
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.zero,
//               fixedSize: Size(100, 100),
//               primary: Colors.transparent,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(7),
//                 side: BorderSide(
//                   color: Colors.grey, // Set the border color
//                   width: 2, // Set the border width
//                 ),
//               ),
//             ),
//             child: Icon(
//               Icons.add_circle_outline_sharp,
//               color: Colors.grey,
//               size: 50,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//             child: Text(
//               'Add Profile',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Color.fromARGB(255, 181, 181, 181),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildProfilesWidget(BuildContext context) {
//     final viewModel = Provider.of<WelcomeViewModel>(context);

//     return Container(
//       padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//       child: Wrap(
//         direction: Axis.horizontal,
//         children: [
//           ...viewModel.profiles
//               .map((profile) => buildProfileWidget(context, profile))
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Widget buildWelcomeTextWidget() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, 2, 0, 20),
//       child: Text(
//         'Welcome!',
//         style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(create: (_) {
//       final viewModel = WelcomeViewModel();
//       viewModel.profileNameController.addListener(viewModel.onModify);
//       return viewModel;
//     }, child: Consumer<WelcomeViewModel>(
//       builder: (context, viewModel, child) {
//         return Scaffold(
//           appBar: AppBar(),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 buildDateWidget(context),
//                 buildWelcomeTextWidget(),
//                 buildProfilesWidget(context),
//                 addProfileButton(viewModel, context),
//               ],
//             ),
//           ),
//         );
//       },
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../viewmodels/welcome_viewmodel.dart';
import '../models/profile_model.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void showAddProfile(WelcomeViewModel viewModel, BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: addProfileWidget(viewModel, context),
        );
      },
    );
  }

  Widget addProfileWidget(WelcomeViewModel viewModel, BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        void listener() {
          if (context.mounted) {
            setState(() {
              viewModel.onModify();
            });
          }
        }

        viewModel.profileNameController.addListener(listener);

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.profileNameController.removeListener(listener);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    foregroundColor: Colors.grey[700],
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextFormField(
                            controller: viewModel.profileNameController,
                            decoration: InputDecoration(
                              labelText: 'Profile Name',
                              labelStyle: TextStyle(
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: viewModel.validProfileDetails
                        ? () {
                            // Add your profile add logic here
                            viewModel.profileNameController
                                .removeListener(listener);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Text('Add Profile'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      elevation: 0,
                      backgroundColor: viewModel.validProfileDetails
                          ? Colors.green
                          : Colors.transparent,
                      foregroundColor: viewModel.validProfileDetails
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => App(name: profile.name)),
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
              showAddProfile(viewModel, context);
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
    return ChangeNotifierProvider(create: (_) {
      final viewModel = WelcomeViewModel();
      viewModel.profileNameController.addListener(viewModel.onModify);
      return viewModel;
    }, child: Consumer<WelcomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
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
      },
    ));
  }
}
