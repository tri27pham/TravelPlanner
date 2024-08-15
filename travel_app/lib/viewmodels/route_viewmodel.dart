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
import '../models/route_place.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class RoutePlannerViewModel extends ChangeNotifier {
  final Completer<GoogleMapController> _mapController = Completer();
  Completer<GoogleMapController> get mapController => _mapController;

  String sessionToken = "12345";
  var uuid = Uuid();

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController startLocationTextEditingController =
      TextEditingController();
  final TextEditingController endLocationTextEditingController =
      TextEditingController();

  final FocusNode mapSearchFocusNode = FocusNode();
  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();

  bool _isEditingSearchLocation = false;
  bool _isEditingStartLocation = false;
  bool _isEditingEndLocation = false;

  bool showStart = true; //get rid of this shit
  bool showEnd = true;

  bool startSelected = false;
  bool destinationSelected = false;

  List<PredictedRoutePlace> places = [];
  List<PredictedRoutePlace> startPlaces = [];
  List<PredictedRoutePlace> endPlaces = [];

  RoutePlace start =
      RoutePlace(placeId: '', name: '', coordinates: LatLng(0, 0));
  RoutePlace destination =
      RoutePlace(placeId: '', name: '', coordinates: LatLng(0, 0));

  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 14);
  final List<Marker> myMarker = [];
  bool _isDisposed = false;

  double containerHeight = 250;

  RoutePlannerViewModel() {
    textEditingController.addListener(onMainSearchModify);
    startLocationTextEditingController.addListener(onStartSearchModify);
    endLocationTextEditingController.addListener(onEndSearchModify);
    mapSearchFocusNode.addListener(onFocusChange);
    startLocationFocusNode.addListener(onFocusChange);
    endLocationFocusNode.addListener(onFocusChange);
    packData();
  }

  Future<RoutePlace> getRoutePlaceInfo(String placeId) async {
    final dio = Dio();
    final String apiKey = 'AIzaSyC3Qfm0kEEILIuqvgu21OnlhSkWoBiyVNQ';
    final String placeImgRequest =
        'https://places.googleapis.com/v1/places/$placeId?fields=id,displayName,location&key=$apiKey';

    try {
      final locationResponse = await dio.get(placeImgRequest);

      RoutePlace routePlace =
          RoutePlace.fromJson(placeId, locationResponse.data);

      destinationSelected = true;
      notifyListeners();
      return routePlace;
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

    return RoutePlace(placeId: 'id', name: '', coordinates: LatLng(0, 0));
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

  Future<List<PredictedRoutePlace>> makeSuggestion(String input) async {
    log(input);
    String apiKey = 'AIzaSyC3Qfm0kEEILIuqvgu21OnlhSkWoBiyVNQ';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$url?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      List<PredictedRoutePlace> predicatedPlaces =
          (responseData['predictions'] as List)
              .map((e) => PredictedRoutePlace.fromJson(e))
              .toList();
      return predicatedPlaces;
    } else {
      throw Exception('FAILED');
    }
  }

  void setStart(RoutePlace selectedPlace) {
    start = selectedPlace;
    startLocationTextEditingController.text = start.name;
    startLocationFocusNode.unfocus();
    notifyListeners();
  }

  void setDestination(RoutePlace selectedPlace) {
    destination = selectedPlace;
    endLocationTextEditingController.text = destination.name;
    endLocationFocusNode.unfocus();
    notifyListeners();
  }

  void setInitialDestination(RoutePlace selectedPlace) {
    destination = selectedPlace;
    textEditingController.text = '';
    endLocationTextEditingController.text = destination.name;
    notifyListeners();
  }

  void onMainSearchModify() async {
    if (textEditingController.text.isEmpty) {
      places.clear();
      notifyListeners();
      return;
    }
    places = await makeSuggestion(textEditingController.text);
    notifyListeners();

    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }
  }

  void onStartSearchModify() async {
    if (startLocationTextEditingController.text.isEmpty) {
      startPlaces.clear();
      notifyListeners();
      return;
    }
    startPlaces = await makeSuggestion(startLocationTextEditingController.text);
    notifyListeners();
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }
  }

  void onEndSearchModify() async {
    if (endLocationTextEditingController.text.isEmpty) {
      endPlaces.clear();
      notifyListeners();
      return;
    }
    endPlaces = await makeSuggestion(endLocationTextEditingController.text);
    notifyListeners();
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }
  }

  void updateContainerHeight() {
    if (mapSearchFocusNode.hasFocus ||
        startLocationFocusNode.hasFocus ||
        endLocationFocusNode.hasFocus) {
      containerHeight = 450;
    } else {
      containerHeight = 350;
    }
    notifyListeners();
  }

  void onFocusChange() {
    log('test');
    updateContainerHeight();
  }

  void resetControllersAndFocus() {
    startLocationFocusNode.unfocus();
    endLocationFocusNode.unfocus();
    destinationSelected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
