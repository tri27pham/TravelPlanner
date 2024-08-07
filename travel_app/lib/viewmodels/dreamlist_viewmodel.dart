import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../models/list_item.dart'; // Import the model

class DreamListViewModel extends ChangeNotifier {
  bool showList = true;

  int _page = 1; // Default page

  // Getter for the page
  int get page => _page;

  // Method to set the page and notify listeners
  void setPage(int newPage) {
    if (newPage != _page) {
      _page = newPage;
      notifyListeners(); // Notify listeners about the change
    }
  }

  final List<Marker> myMarker = [];
  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 10);

  List<ListItem> items = [
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    ListItem(
      title: 'River Stour',
      location: 'Canterbury, England',
      dateAdded: '07/10/24',
      addedBy: 'Mum',
    ),
    // Add more items as needed
  ];

  void toggleView() {
    showList = !showList;
    notifyListeners();
  }

  void disposeController() {
    _mapController.future.then((controller) => controller.dispose());
    super.dispose();
  }

  Completer<GoogleMapController> get mapController => _mapController;
}
