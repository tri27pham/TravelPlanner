// view_models/route_planner_view_model.dart

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/firebase/db_services.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import '../models/predicted_route_place_model.dart';
import '../models/route_place.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/route.dart';

class RoutePlannerViewModel extends ChangeNotifier {
  final Completer<GoogleMapController> _mapController = Completer();
  Completer<GoogleMapController> get mapController => _mapController;
  String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

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

  bool showStart = true; //get rid of this shit
  bool showEnd = true;

  bool startSelected = false;
  bool destinationSelected = false;

  int directRouteDistance = 0;
  String directRouteTime = '0s';

  int dreamlistRouteDistance = 0;
  String dreamlistRouteTime = '0s';

  List<PredictedRoutePlace> places = [];
  List<PredictedRoutePlace> startPlaces = [];
  List<PredictedRoutePlace> endPlaces = [];

  List<DreamListLocation> dreamlistLocationsOnRoute = [];

  Set<Polyline> polyines = {};

  Polyline? directPolyline;

  List<LatLng> polylinePoints = [];

  List<RouteWithDreamlistLocations> routes = [];

  RouteWithDreamlistLocations currentRoute = RouteWithDreamlistLocations(
      polyline: Polyline(polylineId: PolylineId('')),
      origin: RoutePlace(placeId: '', name: '', coordinates: LatLng(0, 0)),
      destination: RoutePlace(placeId: '', name: '', coordinates: LatLng(0, 0)),
      locationsOnRoute: [],
      distance: 0,
      time: '');

  RoutePlace start =
      RoutePlace(placeId: '', name: '', coordinates: LatLng(0, 0));
  RoutePlace destination =
      RoutePlace(placeId: '', name: '', coordinates: LatLng(0, 0));

  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 14);

  Marker? originMarker;
  Marker? destinationMarker;

  List<Marker> markers = [];

  bool _isDisposed = false;

  double containerHeight = 370;

  final db_service = DbService();

  int page = 1;

  double selectedRadius = 10.0;

  RoutePlannerViewModel() {
    textEditingController.addListener(onMainSearchModify);
    startLocationTextEditingController.addListener(onStartSearchModify);
    endLocationTextEditingController.addListener(onEndSearchModify);
    mapSearchFocusNode.addListener(onFocusChange);
    startLocationFocusNode.addListener(onFocusChange);
    endLocationFocusNode.addListener(onFocusChange);
    packData();
  }

  void setRadius(double newRadius) {
    selectedRadius = newRadius;
    notifyListeners();
  }

  void togglePage(int pageNum) {
    page = pageNum;
    notifyListeners();
  }

  Future<void> saveRoute(BuildContext context) async {
    await db_service.addRoute(context, currentRoute);
  }

  Future<void> loadRoutes(BuildContext context) async {
    routes.clear();
    routes = await db_service.loadRoutesFromDb(context);
  }

  Future<void> addNearbyBucketListLocations(BuildContext parentContext) async {
    // Capture the parent context for use in async operations
    final capturedContext = parentContext;

    DbService db_service = DbService();

    List<DreamListLocation> locationsOnRoute = [];
    double radius = selectedRadius * 1000;

    // Use the parent context to load data from the database
    List<DreamListLocation> dreamlistLocations =
        await db_service.loadDreamlistFromDb(capturedContext);

    for (DreamListLocation location in dreamlistLocations) {
      if (await isNearRoute(location, radius)) {
        locationsOnRoute.add(location);
      }
    }

    // Ensure the widget associated with the parent context is still mounted
    if (locationsOnRoute.isNotEmpty && capturedContext.mounted) {
      var points = convertLocations(locationsOnRoute);
      dreamlistLocationsOnRoute = locationsOnRoute;

      // Use the captured parent context for UI-related operations
      addLocationsOnRouteMarker(parentContext, locationsOnRoute);
      await recalculateRoute(points);
    }
  }

  void addLocationsOnRouteMarker(
      BuildContext parentContext, List<DreamListLocation> locations) {
    log('markers: ${markers.length.toString()}');
    log('locations: ${locations.length.toString()}');
    markers.clear();
    markers.add(originMarker!);
    markers.add(destinationMarker!);

    for (DreamListLocation location in locations) {
      log('id: ${location.id}');
      log('coords: ${location.locationCoordinates.toString()}');
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: location.locationCoordinates,
          infoWindow: InfoWindow(
            title: location.name, // Name to display
            snippet: 'Tap to view more info',
            onTap: () {
              // Use the parent context to show dialog
              _showImageDialog(parentContext, location);
            },
          ),
        ),
      );
    }
    log('markers: ${markers.length.toString()}');
    notifyListeners();
  }

  void _showImageDialog(
      BuildContext parentContext, DreamListLocation location) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 1000,
            height: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Text(
                    location.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    location.locationName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 500,
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: location.imageDatas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                  image:
                                      MemoryImage(location.imageDatas[index]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(location.rating.toString()),
                        ),
                        Icon(Icons.star_border_rounded),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(location.numReviews.toString()),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(location.description),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> addNearbyBucketListLocations(BuildContext context) async {
  //   DbService db_service = DbService();

  //   List<DreamListLocation> locationsOnRoute = [];
  //   double radius = selectedRadius * 1000;
  //   List<DreamListLocation> dreamlistLocations =
  //       await db_service.loadDreamlistFromDb(context);

  //   for (DreamListLocation location in dreamlistLocations) {
  //     if (await isNearRoute(location, radius)) {
  //       locationsOnRoute.add(location);
  //     }
  //   }

  //   if (locationsOnRoute.isNotEmpty) {
  //     var points = convertLocations(locationsOnRoute);
  //     dreamlistLocationsOnRoute = locationsOnRoute;
  //     addLocationsOnRouteMarker(context, locationsOnRoute);
  //     await recalculateRoute(points);
  //   }
  // }

  // void addLocationsOnRouteMarker(
  //     BuildContext context, List<DreamListLocation> locations) {
  //   log('markers: ${markers.length.toString()}');
  //   log('locations: ${locations.length.toString()}');
  //   markers.clear();
  //   markers.add(originMarker!);
  //   markers.add(destinationMarker!);
  //   for (DreamListLocation location in locations) {
  //     log('id: ${location.id}');
  //     log('coords: ${location.locationCoordinates.toString()}');
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId(location.id),
  //         position: location.locationCoordinates,
  //         infoWindow: InfoWindow(
  //           title: location.name, // Name to display
  //           snippet: 'Tap to view more info',
  //           onTap: () {
  //             _showImageDialog(context, location);
  //           },
  //         ),
  //       ),
  //       // Marker(
  //       //   markerId: MarkerId(location.id),
  //       //   position: location.locationCoordinates)
  //     );
  //   }
  //   log('markers: ${markers.length.toString()}');
  //   notifyListeners();
  // }

  // void _showImageDialog(BuildContext context, DreamListLocation location) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         child: Container(
  //           width: 1000,
  //           height: 350,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(25), color: Colors.white),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
  //                 child: Text(
  //                   location.name,
  //                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                 child: Text(
  //                   location.locationName,
  //                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   width: 500,
  //                   height: 150,
  //                   child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: location.imageDatas.length,
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
  //                         child: Container(
  //                           // Customize your item here
  //                           width: 150,
  //                           height: 100,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(15)),
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(10),
  //                             child: Image(
  //                                 image:
  //                                     MemoryImage(location.imageDatas[index]),
  //                                 fit: BoxFit.cover),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                   padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                   child: Row(
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                         child: Text(location.rating.toString()),
  //                       ),
  //                       Icon(Icons.star_border_rounded),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                         child: Text(location.numReviews.toString()),
  //                       )
  //                     ],
  //                   )),
  //               Padding(
  //                 padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                 child: Text(location.description),
  //               ),
  //             ],
  //           ),
  //         ), // Display image from memory
  //         // actions: <Widget>[
  //         //   TextButton(
  //         //     child: Text('Close'),
  //         //     onPressed: () {
  //         //       Navigator.of(context).pop();
  //         //     },
  //         //   ),
  //         // ],
  //       );
  //     },
  //   );
  // }

  List<Map<String, dynamic>> convertLocations(
      List<DreamListLocation> locations) {
    return locations
        .map((location) => {
              "location": {
                "latLng": {
                  "latitude": location.locationCoordinates.latitude,
                  "longitude": location.locationCoordinates.longitude
                }
              }
            })
        .toList();
  }

  Future<void> recalculateRoute(
      List<Map<String, dynamic>> locationsOnRoute) async {
    final request = {
      'url': Uri.parse(
          'https://routes.googleapis.com/directions/v2:computeRoutes'),
      'headers': {
        'X-Goog-Api-Key': apiKey,
        'Content-Type': 'application/json',
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
      },
      'body': jsonEncode({
        "origin": {
          "location": {
            "latLng": {
              "latitude": start.coordinates.latitude,
              "longitude": start.coordinates.longitude
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destination.coordinates.latitude,
              "longitude": destination.coordinates.longitude
            }
          }
        },
        "intermediates": locationsOnRoute,
        "travelMode": "DRIVE"
      }),
    };

    try {
      final response = await http.post(
        request['url'] as Uri,
        headers: request['headers'] as Map<String, String>,
        body: request['body'] as String,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Map<String, dynamic> route = data['routes'][0]; // Get the first route
        dreamlistRouteDistance = route['distanceMeters'];
        dreamlistRouteTime = route['duration'];
        String encodedPolyline = route['polyline']['encodedPolyline'];
        List<LatLng> decodedPolyline = decodePolyline(encodedPolyline);
        polylinePoints = decodedPolyline;

        polyines.clear();
        Polyline newPolyline = (Polyline(
          polylineId: PolylineId('route'),
          points: decodedPolyline,
          color: Colors.blue,
          width: 5,
        ));
        directPolyline = newPolyline;

        currentRoute = RouteWithDreamlistLocations(
            polyline: newPolyline,
            origin: start,
            destination: destination,
            locationsOnRoute: dreamlistLocationsOnRoute,
            distance: dreamlistRouteDistance,
            time: dreamlistRouteTime);

        polyines.add(newPolyline);

        adjustCameraToBounds();

        notifyListeners();
      } else {
        print(
            'Request failed with status: ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      print('Error making request: $e');
    }
  }

  Future<void> getCurrentStartLocation() async {
    await Geolocator.requestPermission().then((value) {});
    var uuid = Uuid();
    String randomPlaceId = uuid.v4();
    Position currentLocation = await Geolocator.getCurrentPosition();
    String currentLocationName =
        '${currentLocation.latitude}, ${currentLocation.longitude}';
    LatLng currentLocationCoordinates =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    start = RoutePlace(
        placeId: randomPlaceId,
        name: currentLocationName,
        coordinates: currentLocationCoordinates);
    startLocationTextEditingController.text = currentLocationName;
    startSelected = true;
    setOriginMarker();
    notifyListeners();
    return;
  }

  Future<bool> isNearRoute(DreamListLocation location, double radius) async {
    for (LatLng point in polylinePoints) {
      double distance = Geolocator.distanceBetween(
        location.locationCoordinates.latitude,
        location.locationCoordinates.longitude,
        point.latitude,
        point.longitude,
      );
      // log('${location.name}: ${distance}');
      if (distance <= radius) {
        return true;
      }
    }
    return false;
  }

  List<Marker> get myMarker {
    // List<Marker> markers = [];
    if (originMarker != null) {
      markers.add(originMarker!);
    }
    if (destinationMarker != null) {
      markers.add(destinationMarker!);
    }
    return markers;
  }

  void setOriginMarker() {
    originMarker =
        Marker(markerId: MarkerId(start.placeId), position: start.coordinates);
  }

  void setDestinationtMarker() {
    destinationMarker = Marker(
        markerId: MarkerId(destination.placeId),
        position: destination.coordinates);
  }

  Future<void> getRoute() async {
    final request = {
      'url': Uri.parse(
          'https://routes.googleapis.com/directions/v2:computeRoutes'),
      'headers': {
        'X-Goog-Api-Key': apiKey,
        'Content-Type': 'application/json',
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
      },
      'body': jsonEncode({
        "origin": {
          "location": {
            "latLng": {
              "latitude": start.coordinates.latitude,
              "longitude": start.coordinates.longitude
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destination.coordinates.latitude,
              "longitude": destination.coordinates.longitude
            }
          }
        },
        "travelMode": "DRIVE"
      }),
    };

    try {
      final response = await http.post(
        request['url'] as Uri,
        headers: request['headers'] as Map<String, String>,
        body: request['body'] as String,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Map<String, dynamic> route = data['routes'][0]; // Get the first route
        directRouteDistance = route['distanceMeters'];
        directRouteTime = route['duration'];
        String encodedPolyline = route['polyline']['encodedPolyline'];

        List<LatLng> decodedPolyline = decodePolyline(encodedPolyline);
        polylinePoints = decodedPolyline;

        polyines.clear();
        Polyline newPolyline = (Polyline(
          polylineId: PolylineId('route'),
          points: decodedPolyline,
          color: Colors.blue,
          width: 5,
        ));
        directPolyline = newPolyline;
        polyines.add(newPolyline);

        adjustCameraToBounds();

        notifyListeners();
      } else {
        log('Request failed with status: ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      log('Error making request: $e');
    }
  }

  LatLng getCentreOfMarkers() {
    double totalLat = 0;
    double totalLng = 0;

    for (Marker marker in markers) {
      totalLat += marker.position.latitude;
      totalLng += marker.position.longitude;
    }

    int count = markers.length;
    double centerLat = totalLat / count;
    double centerLng = totalLng / count;

    // log('${centerLat.toString()}, ${centerLng.toString()}');
    return LatLng(centerLat, centerLng);
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
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

  // void _adjustCameraToBounds(List<LatLng> polylinePoints) async {
  //   if (polylinePoints.isEmpty) return;

  //   LatLngBounds bounds;
  //   if (polylinePoints.length == 1) {
  //     bounds = LatLngBounds(
  //       southwest: polylinePoints.first,
  //       northeast: polylinePoints.first,
  //     );
  //   } else {
  //     double minLat = polylinePoints.first.latitude;
  //     double maxLat = polylinePoints.first.latitude;
  //     double minLng = polylinePoints.first.longitude;
  //     double maxLng = polylinePoints.first.longitude;

  //     for (LatLng point in polylinePoints) {
  //       if (point.latitude < minLat) minLat = point.latitude;
  //       if (point.latitude > maxLat) maxLat = point.latitude;
  //       if (point.longitude < minLng) minLng = point.longitude;
  //       if (point.longitude > maxLng) maxLng = point.longitude;
  //     }

  //     bounds = LatLngBounds(
  //       southwest: LatLng(minLat, minLng),
  //       northeast: LatLng(maxLat, maxLng),
  //     );
  //   }

  //   final GoogleMapController controller = await mapController.future;
  //   controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  // }

  LatLngBounds calculatePolylineBounds(List<LatLng> polylinePoints) {
    double minLat = polylinePoints.first.latitude;
    double maxLat = polylinePoints.first.latitude;
    double minLng = polylinePoints.first.longitude;
    double maxLng = polylinePoints.first.longitude;

    for (LatLng point in polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // void adjustCameraToBounds(List<LatLng> polylinePoints) async {
  //   if (polylinePoints.isEmpty) return;

  //   double minLat = polylinePoints.first.latitude;
  //   double maxLat = polylinePoints.first.latitude;
  //   double minLng = polylinePoints.first.longitude;
  //   double maxLng = polylinePoints.first.longitude;

  //   for (LatLng point in polylinePoints) {
  //     if (point.latitude < minLat) minLat = point.latitude;
  //     if (point.latitude > maxLat) maxLat = point.latitude;
  //     if (point.longitude < minLng) minLng = point.longitude;
  //     if (point.longitude > maxLng) maxLng = point.longitude;
  //   }

  //   LatLng southwest = LatLng(minLat, minLng);
  //   LatLng northeast = LatLng(maxLat, maxLng);

  //   LatLngBounds bounds = LatLngBounds(
  //     southwest: southwest,
  //     northeast: northeast,
  //   );

  //   final GoogleMapController controller = await mapController.future;

  //   // Log the bounds for debugging
  //   log('Camera bounds - Southwest: ${southwest.latitude}, ${southwest.longitude}; '
  //       'Northeast: ${northeast.latitude}, ${northeast.longitude}');

  //   controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  // }
  void adjustCameraToBounds() async {
    final GoogleMapController controller = await mapController.future;
    final bounds = calculateBounds();
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    notifyListeners();
  }

  LatLngBounds calculateBounds() {
    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    // Include all marker positions
    for (Marker marker in markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng)
        minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng)
        maxLng = marker.position.longitude;
    }

    // Include all polyline points
    for (LatLng point in polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void packData() {
    getUserLocation().then((value) async {
      if (_isDisposed) return;
      // myMarker.add(Marker(
      //   markerId: const MarkerId('CurrentLocation'),
      //   position: LatLng(value.latitude, value.longitude),
      //   infoWindow: const InfoWindow(title: 'CurrentLocation'),
      // ));
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 11);
      final GoogleMapController controller = await _mapController.future;
      if (_isDisposed) return;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      if (_isDisposed) return;
      notifyListeners();
    });
  }

  Future<List<PredictedRoutePlace>> makeSuggestion(String input) async {
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
    startSelected = true;
    setOriginMarker();
    startLocationFocusNode.unfocus();
    if (startSelected && destinationSelected) {
      getRoute();
    }
    notifyListeners();
  }

  void setDestination(RoutePlace selectedPlace) {
    destination = selectedPlace;
    endLocationTextEditingController.text = destination.name;
    destinationSelected = true;
    setDestinationtMarker();
    endLocationFocusNode.unfocus();
    if (startSelected && destinationSelected) {
      getRoute();
    }
    notifyListeners();
  }

  void setInitialDestination(RoutePlace selectedPlace) {
    destination = selectedPlace;
    textEditingController.text = '';
    endLocationTextEditingController.text = destination.name;
    setDestinationtMarker();
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
      containerHeight = 370;
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

  int convertMetersToMiles(int distance) {
    const double metersPerMile = 1609.34;

    // Convert meters to miles
    double distanceInMiles = distance / metersPerMile;

    // Round to the nearest mile
    return distanceInMiles.round();
  }

  String convertTime(String time) {
    // Extract the numeric part from the input string by removing the trailing 's'
    int totalSeconds = int.parse(time.replaceAll('s', ''));

    // Calculate the number of hours
    int hours = totalSeconds ~/ 3600;

    int remainingSeconds = totalSeconds % 3600;

    // Calculate the number of minutes from the remaining seconds
    int minutes = remainingSeconds ~/ 60;

    // Return the formatted string with hours and remaining seconds
    return '$hours h $minutes mins';
  }

  int getDirectRouteDistance() {
    return convertMetersToMiles(directRouteDistance);
  }

  int getDreamlistRouteDistance() {
    return convertMetersToMiles(dreamlistRouteDistance);
  }

  String getDirectRouteTime() {
    return convertTime(directRouteTime);
  }

  String getDreamlistRouteTime() {
    return convertTime(dreamlistRouteTime);
  }

  int getDistanceDifference() {
    return convertMetersToMiles(dreamlistRouteDistance - directRouteDistance);
  }

  String getTimeDifference() {
    int differenceSeconds = int.parse(dreamlistRouteTime.replaceAll('s', '')) -
        int.parse(directRouteTime.replaceAll('s', ''));
    int hours = differenceSeconds ~/ 3600;

    int remainingSeconds = differenceSeconds % 3600;

    // Calculate the number of minutes from the remaining seconds
    int minutes = remainingSeconds ~/ 60;

    // Return the formatted string with hours and remaining seconds
    return '$hours h $minutes mins';
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
