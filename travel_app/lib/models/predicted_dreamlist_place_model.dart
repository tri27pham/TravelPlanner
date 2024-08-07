import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictedDreamlistPlace {
  final String description;
  final String placeId;

  PredictedDreamlistPlace({required this.description, required this.placeId});

  factory PredictedDreamlistPlace.fromJson(Map<String, dynamic> json) {
    return PredictedDreamlistPlace(
        description: json['description'], placeId: json['place_id']);
  }
}
