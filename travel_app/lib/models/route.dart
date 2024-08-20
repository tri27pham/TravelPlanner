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
}
