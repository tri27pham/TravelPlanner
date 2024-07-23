import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Place {
  final String description;

  Place({required this.description});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(description: json['description']);
  }
}
