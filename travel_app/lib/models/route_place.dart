import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class RoutePlace {
  final String placeId;
  final String name;
  final LatLng coordinates;

  RoutePlace(
      {required this.placeId, required this.name, required this.coordinates});

  factory RoutePlace.fromJson(String placeId, Map<String, dynamic> json) {
    return RoutePlace(
        placeId: placeId,
        name: json['displayName']['text'] != null
            ? json['displayName']['text']
            : 'test',
        coordinates: json['location']['latitude'] != null &&
                json['location']['longitude'] != null
            ? LatLng(
                json['location']['latitude'], json['location']['longitude'])
            : LatLng(0, 0));
  }
}
