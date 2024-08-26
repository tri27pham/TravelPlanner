import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/route.dart';
import '../viewmodels/route_viewmodel.dart';
import 'dart:developer';

class ViewSavedRoutes extends StatelessWidget {
  const ViewSavedRoutes({super.key});

  void showRoutePopup(BuildContext context, RouteWithDreamlistLocations route) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RoutePopUpWidget(context, route);
      },
      barrierDismissible:
          true, // Allows dialog to be dismissed by tapping outside
    );
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
      child: InkWell(
        onTap: () {
          // route.showImageData();
          showRoutePopup(context, route);
        },
        borderRadius: BorderRadius.circular(
            15), // Ensures ripple effect is contained within rounded corners
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[200],
          ),
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
                  '${(route.getDistance()).toString()} miles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
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
                    scrollDirection: Axis.horizontal,
                    itemCount: route.locationsOnRoute.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                          // Customize your item here
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                                image: MemoryImage(route
                                    .locationsOnRoute[index].imageDatas.first),
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget RoutePopUpWidget(
      BuildContext context, RouteWithDreamlistLocations route) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      insetPadding:
          EdgeInsets.zero, // Remove default padding to use full width/height
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width:
            MediaQuery.of(context).size.width * 0.9, // Example width adjustment
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      route.origin.name,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(Icons.arrow_forward_outlined, size: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      route.destination.name,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(
                'Distance: ${route.getDistance()} miles',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(
                'Distance: ${route.getTime()}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 0, 10),
              child: Container(
                width: 300,
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: route.locationsOnRoute.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Container(
                        // Customize your item here
                        width: 150,
                        height: 125,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                              image: MemoryImage(route
                                  .locationsOnRoute[index].imageDatas.first),
                              fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.45,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                      initialCameraPosition: RoutePlannerViewModel.initPos,
                      markers: route.getMarkers(context),
                      polylines: {
                        route.polyline,
                      }),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.green,
                        foregroundColor: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
