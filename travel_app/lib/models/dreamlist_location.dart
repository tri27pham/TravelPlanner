import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer';

class DreamListLocation {
  final String id;
  final String name;
  final String locationName;
  final LatLng locationCoordinates;
  final String description;
  final double rating;
  final int numReviews;
  List<String> photoRefs = [];
  String? addedOn;
  String? addedBy;

  DreamListLocation(
      {required this.id,
      required this.name,
      required this.locationName,
      required this.locationCoordinates,
      required this.description,
      required this.rating,
      required this.numReviews,
      required this.photoRefs,
      required this.addedOn,
      required this.addedBy});

  displayInfo() {
    log(id);
    log(name);
    log(locationName);
    log(locationCoordinates.toString());
    log(description);
    log(rating.toString());
    log(numReviews.toString());
    for (String photoRef in photoRefs) {
      log(photoRef);
    }
  }

  factory DreamListLocation.fromJson(Map<String, dynamic> json) {
    List<String> photoRefs = [];

    if (json['photos'] != null) {
      for (var photo in json['photos']) {
        photoRefs.add(photo['name']);
      }
    }
    return DreamListLocation(
        id: json.containsKey('id') ? json['id'] : 'no id',
        name: json.containsKey('displayName') &&
                json['displayName'].containsKey('text') &&
                json['displayName']['text'] != null
            ? json['displayName']['text']
            : 'no name',
        locationName: json.containsKey('formattedAddress') &&
                json['formattedAddress'] != null
            ? json['formattedAddress']
            : 'no location',
        locationCoordinates: LatLng(
          json.containsKey('location') &&
                  json['location'].containsKey('latitude') &&
                  json['location']['latitude'] != null
              ? json['location']['latitude']
              : 0.0,
          json.containsKey('location') &&
                  json['location'].containsKey('longitude') &&
                  json['location']['longitude'] != null
              ? json['location']['longitude']
              : 0.0,
        ),
        description: json.containsKey('editorialSummary') &&
                json['editorialSummary'].containsKey('text') &&
                json['editorialSummary']['text'] != null
            ? json['editorialSummary']['text']
            : 'no description',
        rating: json.containsKey('rating') && json['rating'] != null
            ? json['rating'].toDouble()
            : 0.0,
        numReviews: json.containsKey('userRatingCount') &&
                json['userRatingCount'] != null
            ? json['userRatingCount']
            : 0,
        photoRefs: photoRefs,
        addedOn: json.containsKey('addedOn') && json['addedOn'] != null
            ? json['addedOn'].toString()
            : '',
        addedBy: json.containsKey('addedBy') && json['addedBy'] != null
            ? json['addedBy']
            : '');
  }
}
