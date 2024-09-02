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

  // Set<String> _segmentSelected = {'0'};

  bool viewVisited = false;

  // Set<String> get segmentSelected => _segmentSelected;

  void updateSegmentSelected(bool visited) {
    viewVisited = visited;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  int get page => _page;

  bool locationsLoaded = false;
  List<DreamListLocation> locations = [];
  List<DreamListLocation> visitedLocations = [];
  List<DreamListLocation> notVisitedLocations = [];

  void setPage(int newPage) {
    if (newPage != _page) {
      _page = newPage;
      notifyListeners();
    }
  }

  final db_service = DbService();

  Set<Marker> createMarkers(BuildContext context) {
    // markers.clear();

    Set<Marker> markers = {};

    for (DreamListLocation location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: location.locationCoordinates,
          infoWindow: InfoWindow(
            title: location.name, // Name to display
            snippet: 'Tap to view more info',
            onTap: () {
              // Use the parent context to show diadev.log
              _showImageDialog(context, location);
            },
          ),
        ),
      );
      // markers.add(Marker(
      //     markerId: MarkerId(location.name),
      //     position: location.locationCoordinates,
      //     icon: BitmapDescriptor.defaultMarker));
    }
    return markers;
  }

  void _showImageDialog(BuildContext context, DreamListLocation location) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 1000,
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Added By: ', // Regular text
                                ),
                                TextSpan(
                                  text: location.addedBy, // Text to be bold
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Added On: ', // Regular text
                                ),
                                TextSpan(
                                  text: location.addedOn, // Text to be bold
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
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

  Future<void> loadLocations(BuildContext context) async {
    if (locationsLoaded) {
      return;
    }
    try {
      locations = await db_service.loadDreamlistFromDb(context);
      visitedLocations =
          locations.where((location) => location.visited).toList();
      notVisitedLocations =
          locations.where((location) => !location.visited).toList();
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

  Future<void> updateDreamlistLocation(
      BuildContext context, DreamListLocation location) async {
    await db_service.updateDreamlistLocation(context, location);
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
