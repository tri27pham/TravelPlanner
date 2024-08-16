import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class PredictedRoutePlace {
  final String placeId;
  final String description;

  PredictedRoutePlace({required this.placeId, required this.description});

  factory PredictedRoutePlace.fromJson(Map<String, dynamic> json) {
    return PredictedRoutePlace(
        placeId: json['place_id'], description: json['description']);
  }
}
