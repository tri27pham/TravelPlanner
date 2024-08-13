import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/predicted_dreamlist_place_model.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import '../firebase/db_services.dart';

class DreamListLocationViewModel extends ChangeNotifier {
  final DbService db_service = DbService();

  bool showList = true;

  bool _locationSelected = false;

  bool get locationSelected => _locationSelected;

  set locationSelected(bool value) {
    if (_locationSelected != value) {
      _locationSelected = value;
      notifyListeners();
    }
  }

  String sessionToken = "12345";
  var uuid = Uuid();

  List<PredictedDreamlistPlace> places = [];

  final TextEditingController textEditingController = TextEditingController();

  DreamListLocation selectedLocation = DreamListLocation(
      id: 'id',
      name: 'name',
      locationName: 'locationName',
      locationCoordinates: LatLng(0, 0),
      description: 'description',
      rating: 0,
      numReviews: 0,
      photoRefs: []);

  DreamListLocationViewModel() {
    textEditingController.addListener(onModify);
  }

  void selectLocation(DreamListLocation listLocation) {
    selectedLocation = listLocation;
    locationSelected = true;
  }

  Future<void> addLocationToDb(BuildContext context) async {
    await db_service.addBucketListLocation(context, selectedLocation);
    Navigator.pop(context);
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
}
