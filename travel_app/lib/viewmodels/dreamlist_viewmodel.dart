import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../models/dreamlist_item.dart';

class DreamListViewModel extends ChangeNotifier {
  bool showList = true;
  final List<Marker> myMarker = [];
  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 10);

  List<DreamListItem> dreamListItems = [
    DreamListItem(
      title: 'River Stour',
      locationName: 'Canterbury, England',
      locationCoordinates: LatLng(51.2798, 1.0835),
      addedOn: '07/10/24',
      addedBy: 'Mum',
      // imageUrl:
      //     'assets/river_stour.png', // Replace with actual image path or URL
    ),
    // Add more items here...
  ];

  void toggleView() {
    showList = !showList;
    notifyListeners();
  }

  Completer<GoogleMapController> get mapController => _mapController;

  void disposeMapController() async {
    final controller = await _mapController.future;
    controller.dispose();
  }
}
