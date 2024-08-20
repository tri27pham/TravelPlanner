import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/route.dart';
import '../viewmodels/route_viewmodel.dart';

class ViewSavedRoutes extends StatelessWidget {
  const ViewSavedRoutes({super.key});

  int metersToNearestMile(int meters) {
    const double metersPerMile = 1609.344; // 1 mile = 1609.344 meters
    double miles = meters / metersPerMile;
    return miles.toInt(); // Rounds to the nearest mile
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutePlannerViewModel>(
      builder: (context, viewModel, child) {
        return FutureBuilder<void>(
          future: viewModel.loadRoutes(context), // Call the method here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner while waiting for the method to complete
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error state
              return Center(child: Text('Error loading saved routes'));
            } else {
              // If the future is complete, show the actual UI
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
                              children: [
                                Container(
                                  height: 45,
                                  width: 60,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      viewModel
                                          .togglePage(1); // Use the ViewModel
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
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 100),
                              itemCount: viewModel
                                  .routes.length, // Number of items in the list
                              itemBuilder: (context, index) {
                                final route = viewModel.routes[
                                    index]; // Get the route at this index
                                return RouteWidget(context, route);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget RouteWidget(BuildContext context, RouteWithDreamlistLocations route) {
    final viewModel = Provider.of<RoutePlannerViewModel>(context);
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.grey[200]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Text(
                        route.origin.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 22,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: Text(
                        route.destination.name,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    '${metersToNearestMile(route.distance).toString()} miles',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'Dreamlist locations visited: ',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Container(
                  width: 300,
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis
                        .horizontal, // Set the scroll direction to horizontal
                    itemCount:
                        viewModel.routes.length, // Number of items in the list
                    itemBuilder: (context, index) {
                      return Container(
                          // width: 80.0,
                          // margin: EdgeInsets.symmetric(horizontal: 5.0),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          //   image: DecorationImage(
                          //     image: MemoryImage(viewModel
                          //         .routes
                          //         .first
                          //         .locationsOnRoute
                          //         .first
                          //         .imageDatas
                          //         .first), // Use MemoryImage with Uint8List
                          //     fit: BoxFit
                          //         .cover, // Ensures the image covers the entire container
                          //   ),
                          // ),
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
