// view_models/route_planner_view_model.dart

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import '../models/predicted_route_place_model.dart';

class RoutePlannerViewModel extends ChangeNotifier {
  final Completer<GoogleMapController> _mapController = Completer();
  Completer<GoogleMapController> get mapController => _mapController;

  String sessionToken = "12345";
  var uuid = Uuid();

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController startLocationTextEditingController =
      TextEditingController();

  final FocusNode mapSearchFocusNode = FocusNode();
  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();

  bool _isEditingSearchLocation = false;
  bool _isEditingStartLocation = false;
  bool _isEditingEndLocation = false;

  bool showStart = true;
  bool showEnd = true;

  List<PredictedRoutePlace> places = [];

  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 14);
  final List<Marker> myMarker = [];
  bool _isDisposed = false;

  double containerHeight = 250;

  bool createRoute = false;

  RoutePlannerViewModel() {
    textEditingController.addListener(onModify);
    mapSearchFocusNode.addListener(onFocusChange);
    startLocationFocusNode.addListener(onFocusChange);
    endLocationFocusNode.addListener(onFocusChange);
    packData();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
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

  void makeSuggestion(String input) async {
    String apiKey = 'AIzaSyC3Qfm0kEEILIuqvgu21OnlhSkWoBiyVNQ';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$url?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      places = (responseData['predictions'] as List)
          .map((e) => PredictedRoutePlace.fromJson(e))
          .toList();
      notifyListeners();
    } else {
      throw Exception('FAILED');
    }
  }

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

  void updateContainerHeight() {
    print('test');
    if (_isEditingSearchLocation ||
        _isEditingStartLocation ||
        _isEditingEndLocation) {
      containerHeight = 450;
    } else {
      containerHeight = 250;
    }
    notifyListeners();
  }

  void updateStartEndSearch() {
    if (_isEditingStartLocation) {
      showEnd = false;
    } else if (_isEditingEndLocation) {
      showStart = false;
    }
    if (!_isEditingStartLocation && !_isEditingEndLocation) {
      showStart = true;
      showEnd = true;
    }
    notifyListeners();
  }

  void onFocusChange() {
    print('test focus');
    _isEditingSearchLocation = mapSearchFocusNode.hasFocus;
    _isEditingStartLocation = startLocationFocusNode.hasFocus;
    _isEditingEndLocation = endLocationFocusNode.hasFocus;
    updateContainerHeight();
    updateStartEndSearch();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
