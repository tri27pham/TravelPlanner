import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictedRoutePlace {
  final String description;

  PredictedRoutePlace({required this.description});

  factory PredictedRoutePlace.fromJson(Map<String, dynamic> json) {
    return PredictedRoutePlace(description: json['description']);
  }
}
