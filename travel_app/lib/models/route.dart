import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import 'package:travel_app/models/route_place.dart';
import 'dart:developer';

class RouteWithDreamlistLocations {
  String id;
  Polyline polyline;
  RoutePlace origin;
  RoutePlace destination;
  List<DreamListLocation> locationsOnRoute;
  int directDistance;
  int indirectDistance;
  int distanceDifference;
  String directTime;
  String indirectTime;
  String timeDifference;

  RouteWithDreamlistLocations({
    required this.id,
    required this.polyline,
    required this.origin,
    required this.destination,
    required this.locationsOnRoute,
    required this.directDistance,
    required this.indirectDistance,
    required this.distanceDifference,
    required this.directTime,
    required this.indirectTime,
    required this.timeDifference,
  });

  void showImageData() {
    if (locationsOnRoute.isNotEmpty) {
      log('has locations');
      for (DreamListLocation location in locationsOnRoute) {
        if (location.imageDatas.isNotEmpty) {
          log(location.imageDatas.first.toString());
        }
      }
    } else {
      log('fuck');
    }
  }

  Set<Marker> getMarkers(BuildContext context) {
    Set<Marker> markers = {};

    for (DreamListLocation location in locationsOnRoute) {
      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: location.locationCoordinates,
          infoWindow: InfoWindow(
            title: location.name, // Name to display
            snippet: 'Tap to view more info',
            onTap: () {
              _showImageDialog(context, location);
            },
          ),
        ),
      );
    }

    markers.add(
      Marker(
        markerId: MarkerId(origin.name),
        position: origin.coordinates,
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId(destination.name),
        position: destination.coordinates,
      ),
    );

    return markers;
  }

  LatLngBounds calculateBounds() {
    if (locationsOnRoute.isEmpty)
      return LatLngBounds(
        southwest: LatLng(0, 0),
        northeast: LatLng(0, 0),
      ); // Default if no coordinates

    double minLat = locationsOnRoute.first.locationCoordinates.latitude;
    double maxLat = locationsOnRoute.first.locationCoordinates.latitude;
    double minLng = locationsOnRoute.first.locationCoordinates.latitude;
    double maxLng = locationsOnRoute.first.locationCoordinates.longitude;

    for (DreamListLocation location in locationsOnRoute) {
      LatLng coord = location.locationCoordinates;
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _showImageDialog(BuildContext context, DreamListLocation location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 1000,
            height: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Text(
                    location.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    location.locationName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: location.imageDatas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Container(
                            // Customize your item here
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                  image:
                                      MemoryImage(location.imageDatas[index]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(location.rating.toString()),
                        ),
                        Icon(Icons.star_border_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(location.numReviews.toString()),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(location.description),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int convertDistance(int distanceInMeters) {
    const double metersPerMile = 1609.344; // 1 mile = 1609.344 meters
    double miles = distanceInMeters / metersPerMile;
    return miles.toInt(); // Rounds to the nearest mile
  }

  int getDirectDistance() {
    return convertDistance(directDistance);
  }

  int getIndirectDistance() {
    return convertDistance(indirectDistance);
  }

  int getDistanceDifference() {
    return distanceDifference;
  }

  String getDirectTime() {
    return convertTime(directTime);
  }

  String getIndirectTime() {
    return convertTime(indirectTime);
  }

  String getTimeDifference() {
    int totalSeconds = int.parse(indirectTime.replaceAll('s', '')) -
        int.parse(directTime.replaceAll('s', ''));

    // Calculate hours and minutes
    int hours = totalSeconds ~/ 3600; // 1 hour = 3600 seconds
    int minutes = (totalSeconds % 3600) ~/ 60; // Remaining minutes

    // Create the formatted string
    return '${hours}h ${minutes}m';
  }

  String convertTime(String time) {
    // Remove the trailing 's' and parse the number
    int totalSeconds = int.parse(time.replaceAll('s', ''));

    // Calculate hours and minutes
    int hours = totalSeconds ~/ 3600; // 1 hour = 3600 seconds
    int minutes = (totalSeconds % 3600) ~/ 60; // Remaining minutes

    // Create the formatted string
    return '${hours}h ${minutes}m';
  }
}
