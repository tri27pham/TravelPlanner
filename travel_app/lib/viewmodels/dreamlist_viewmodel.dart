import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/predicted_dreamlist_place_model.dart';
import '../models/list_item.dart'; // Import the model
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import '../models/predicted_route_place_model.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class DreamListViewModel extends ChangeNotifier {
  int _page = 1; // Default page

  int get page => _page;

  void setPage(int newPage) {
    if (newPage != _page) {
      _page = newPage;
      notifyListeners(); // Notify listeners about the change
    }
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
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
  ];

  void disposeController() {
    _mapController.future.then((controller) => controller.dispose());
    super.dispose();
  }

  Completer<GoogleMapController> get mapController => _mapController;
}
