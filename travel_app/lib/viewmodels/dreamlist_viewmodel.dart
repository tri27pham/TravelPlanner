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

  DreamListViewModel() {
    textEditingController.addListener(onModify);
    packData();
  }

  Future<DreamListLocation> getDreamlistLocationInfo(String placeId) async {
    final String apiKey = 'AIzaSyC3Qfm0kEEILIuqvgu21OnlhSkWoBiyVNQ';
    final String placeImgRequest =
        'https://places.googleapis.com/v1/places/$placeId?fields=id,displayName,editorial_summary,location,formattedAddress,userRatingCount,photos,rating&key=$apiKey';
    final dio = Dio();

    try {
      final response = await dio.get(placeImgRequest);
      DreamListLocation dreamlistLocation =
          DreamListLocation.fromJson(response.data);
      return dreamlistLocation;
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      if (e.response != null) {
        log('Error response: ${e.response?.statusCode} ${e.response?.statusMessage}');
        log('Response data: ${e.response?.data}');
      } else {
        log('Error request: ${e.message}');
      }
    } catch (e) {
      log('General error: $e');
    }

    return DreamListLocation(
        id: 'id',
        name: 'name',
        locationName: 'locationName',
        locationCoordinates: LatLng(0, 0),
        description: 'description',
        rating: 0,
        numReviews: 0,
        photoRefs: []);
  }

  void packData() {
    getUserLocation().then((value) async {
      if (_isDisposed) return;
      myMarker.add(Marker(
        markerId: const MarkerId('CurrentLocation'),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(title: 'CurrentLocation'),
      ));
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);
      final GoogleMapController controller = await _mapController.future;
      if (_isDisposed) return;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      if (_isDisposed) return;
      notifyListeners();
    });
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  }

  bool _isDisposed = false;

  String sessionToken = "12345";
  var uuid = Uuid();

  List<PredictedDreamlistPlace> places = [];

  final TextEditingController textEditingController = TextEditingController();

  final List<Marker> myMarker = [];
  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 10);

  void onModify() {
    if (textEditingController.text.isEmpty) {
      places.clear();
      notifyListeners();
      return;
    }
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }
    makeSuggestion(textEditingController.text);
  }

  void makeSuggestion(String input) async {
    String apiKey = 'AIzaSyC3Qfm0kEEILIuqvgu21OnlhSkWoBiyVNQ';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$url?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      places = (responseData['predictions'] as List)
          .map((e) => PredictedDreamlistPlace.fromJson(e))
          .toList();
      notifyListeners();
    } else {
      throw Exception('FAILED');
    }
  }

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

  void disposeController() {
    _mapController.future.then((controller) => controller.dispose());
    super.dispose();
  }

  Completer<GoogleMapController> get mapController => _mapController;
}
