import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/route_place.dart';

class Route {
  Polyline polyline;
  RoutePlace origin;
  RoutePlace destination;
  List<RoutePlace> locationsOnRoute;
  double distance;
  DateTime time;

  Route({
    required this.polyline,
    required this.origin,
    required this.destination,
    required this.locationsOnRoute,
    required this.distance,
    required this.time,
  });
}
