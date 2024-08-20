import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/route_viewmodel.dart'; // Make sure to import the RoutePlannerViewModel

class ViewSavedRoutes extends StatelessWidget {
  const ViewSavedRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutePlannerViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            Positioned(
              top: -35,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/grandcanyon.png',
                fit: BoxFit.fitWidth,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    topRight: Radius.circular(60.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -2),
                      blurRadius: 1,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 45,
                            width: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.togglePage(1); // Use the ViewModel
                              },
                              child: Icon(Icons.arrow_back_sharp),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[900],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 40),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Text(
                                  'Saved Routes',
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget YourListWidget() {
  //   return Expanded(
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //       child: Consumer<RoutePlannerViewModel>(
  //         builder: (context, viewModel, child) {
  //           return ListView.builder(
  //             padding: EdgeInsets.only(bottom: 10),
  //             itemCount: viewModel.locations.length,
  //             itemBuilder: (context, index) {
  //               final location = viewModel.locations[index];
  //               return ListItem(location, context);
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
