import 'package:google_maps_flutter/google_maps_flutter.dart';

class DreamListItem {
  final String title;
  final String locationName;
  final LatLng locationCoordinates;
  final String addedOn;
  final String addedBy;
  // final String imageUrl;

  DreamListItem({
    required this.title,
    required this.locationName,
    required this.locationCoordinates,
    required this.addedOn,
    required this.addedBy,
    // required this.imageUrl,
  });
}
