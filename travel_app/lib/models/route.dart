import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import 'package:travel_app/models/route_place.dart';

class RouteWithDreamlistLocations {
  Polyline polyline;
  RoutePlace origin;
  RoutePlace destination;
  List<DreamListLocation> locationsOnRoute;
  int distance;
  String time;

  RouteWithDreamlistLocations({
    required this.polyline,
    required this.origin,
    required this.destination,
    required this.locationsOnRoute,
    required this.distance,
    required this.time,
  });

  Set<Marker> getMarkers() {
    Set<Marker> markers = {};

    for (DreamListLocation location in locationsOnRoute) {
      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: location.locationCoordinates,
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

  int getDistance() {
    const double metersPerMile = 1609.344; // 1 mile = 1609.344 meters
    double miles = distance / metersPerMile;
    return miles.toInt(); // Rounds to the nearest mile
  }

  String getTime() {
    // Remove the trailing 's' and parse the number
    int totalSeconds = int.parse(time.replaceAll('s', ''));

    // Calculate hours and minutes
    int hours = totalSeconds ~/ 3600; // 1 hour = 3600 seconds
    int minutes = (totalSeconds % 3600) ~/ 60; // Remaining minutes

    // Create the formatted string
    return '${hours}h ${minutes}m';
  }
}
