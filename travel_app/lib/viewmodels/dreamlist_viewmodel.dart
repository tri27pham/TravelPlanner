import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import 'dart:async';
import '../models/list_item.dart';
import 'package:geolocator/geolocator.dart';
import '../firebase/db_services.dart';
import 'dart:developer';
import '../models/dreamlist_location.dart';

class DreamListViewModel extends ChangeNotifier {
  int _page = 1;

  Set<String> _segmentSelected = {'0'};

  Set<String> get segmentSelected => _segmentSelected;

  void updateSegmentSelected(Set<String> newSelection) {
    _segmentSelected = newSelection;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  int get page => _page;

  bool locationsLoaded = false;
  List<DreamListLocation> locations = [];

  void setPage(int newPage) {
    if (newPage != _page) {
      _page = newPage;
      notifyListeners();
    }
  }

  final db_service = DbService();

  createMarkers() {
    markers.clear();
    for (DreamListLocation location in locations) {
      log(location.name);
      log(location.locationCoordinates.toString());
      markers.add(Marker(
          markerId: MarkerId(location.name),
          position: location.locationCoordinates,
          icon: BitmapDescriptor.defaultMarker));
    }
  }

  Future<void> loadLocations(BuildContext context) async {
    if (locationsLoaded) {
      return;
    }
    try {
      locations = await db_service.loadDreamlistFromDb(context);
      createMarkers();
      locationsLoaded = true;
      log('Locations loaded successfully.');
      log(locations.length.toString());
      notifyListeners();
    } catch (e) {
      log('Error loading locations: $e');
    }
  }

  Future<void> deleteDreamlistLocation(
      BuildContext context, DreamListLocation location) async {
    await db_service.deleteDreamListLocation(context, location);
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> markers = [];

  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 10);

  void disposeController() {
    _mapController.future.then((controller) => controller.dispose());
    locationsLoaded = false;
    super.dispose();
  }

  Completer<GoogleMapController> get mapController => _mapController;
}
