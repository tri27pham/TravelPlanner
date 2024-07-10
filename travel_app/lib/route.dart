import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:geocoding/geocoding.dart';

class RoutePlanner extends StatefulWidget {
  const RoutePlanner({super.key});

  @override
  State<RoutePlanner> createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {
  final Completer<GoogleMapController> _mapController = Completer();

  String sessionToken = "12345";

  var uuid = Uuid();

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _mapSearchFocusNode = FocusNode();
  final FocusNode _startLocationFocusNode = FocusNode();
  final FocusNode _endLocationFocusNode = FocusNode();

  bool _isEditingSearchLocation = false;
  bool _isEditingStartLocation = false;
  bool _isEditingEndLocation = false;

  bool showStart = true;
  bool showEnd = true;

  List<dynamic> places = [];

  final TextEditingController _startLocationTextEditingController =
      TextEditingController();

  static const CameraPosition initPos =
      CameraPosition(target: LatLng(51.5131, 0.1174), zoom: 14);

  final List<Marker> myMarker = [];
  bool _isDisposed = false;

  double _containerHeight = 250;

  bool createRoute = false;

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  packData() {
    getUserLocation().then((value) async {
      if (_isDisposed) return; // Check if the widget is disposed
      myMarker.add(Marker(
          markerId: const MarkerId('CurrentLocation'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'CurrentLocation',
          )));
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      final GoogleMapController controller = await _mapController.future;
      if (_isDisposed) return; // Check again before calling animateCamera
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      if (_isDisposed) return; // Check again before calling setState
      setState(() {});
    });
  }

  void makeSuggestion(String input) async {
    String apiKey = 'AIzaSyC3Qfm0kEEILIuqvgu21OnlhSkWoBiyVNQ';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$url?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    var responseData = response.body.toString();

    print("test");
    print(responseData);
    print("test");

    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(responseData)['predictions'];
      });
    } else {
      throw Exception('FAILED');
    }
  }

  void onModify() {
    if (_textEditingController.text.isEmpty) {
      setState(() {
        places.clear(); // Empty the places list
      });
      return; // Exit the method early if the controller is empty
    }
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    makeSuggestion(_textEditingController.text);
  }

  void updateContainerHeight() {
    if (_isEditingSearchLocation ||
        _isEditingStartLocation ||
        _isEditingEndLocation) {
      setState(() {
        _containerHeight = 400;
      });
    } else {
      setState(() {
        _containerHeight = 250;
      });
    }
  }

  updateStartEndSearch() {
    if (_isEditingStartLocation) {
      setState(() {
        showEnd = false;
      });
    } else if (_isEditingEndLocation) {
      setState(() {
        showStart = false;
      });
    }
    if (!_isEditingStartLocation && !_isEditingEndLocation) {
      setState(() {
        showStart = true;
        showEnd = true;
      });
    }
  }

  Widget MapWidget() {
    return GoogleMap(
      initialCameraPosition: initPos,
      mapType: MapType.normal,
      markers: Set<Marker>.of(myMarker),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Widget SearchBarWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _textEditingController.text.isEmpty ? 350 : 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Color.fromARGB(255, 240, 240, 240), // Background color
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        child: TextFormField(
                          controller: _textEditingController,
                          focusNode: _mapSearchFocusNode,
                          decoration: InputDecoration(
                              hintText:
                                  'Search for a location or search by image',
                              hintStyle: TextStyle(
                                  color: Colors.grey, // Set the hint text color
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                _textEditingController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _textEditingController.text = '';
                            },
                            child: Icon(Icons.arrow_back_sharp),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey[900],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 40)),
                          ),
                        ))
                    : Container(),
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _textEditingController.text.isNotEmpty
                  ? _containerHeight / 1.75
                  : 0,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height *
                          0.06, // Specify the desired height
                      width:
                          MediaQuery.of(context).size.width, // Use full width
                      child: ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              places[index]['description']);
                          print(locations.last.longitude);
                          print(locations.last.latitude);
                        },
                        leading: Icon(Icons.location_on),
                        title: Text(
                          places[index]['description'],
                          overflow: TextOverflow
                              .ellipsis, // Use ellipsis to indicate truncation
                          maxLines: 1,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget StartLocationSearchBarWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _textEditingController.text.isEmpty ? 350 : 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Color.fromARGB(255, 240, 240, 240), // Background color
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        width: 65,
                        child: Text('Start'),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 50,
                        child: TextFormField(
                          controller: _textEditingController,
                          focusNode: _startLocationFocusNode,
                          decoration: InputDecoration(
                              hintText: 'Tap to search',
                              hintStyle: TextStyle(
                                  color: Colors.grey, // Set the hint text color
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13),
                              border: InputBorder.none),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.my_location_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.all(0))),
                        ),
                      ),
                    ],
                  ),
                ),
                _textEditingController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _startLocationTextEditingController.text = '';
                            },
                            child: Icon(Icons.arrow_back_sharp),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey[900],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 40)),
                          ),
                        ))
                    : Container(),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _textEditingController.text.isNotEmpty
                  ? _containerHeight / 1.75
                  : 0,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height *
                          0.06, // Specify the desired height
                      width:
                          MediaQuery.of(context).size.width, // Use full width
                      child: ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              places[index]['description']);
                          print(locations.last.longitude);
                          print(locations.last.latitude);
                        },
                        leading: Icon(Icons.location_on),
                        title: Text(
                          places[index]['description'],
                          overflow: TextOverflow
                              .ellipsis, // Use ellipsis to indicate truncation
                          maxLines: 1,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget EndLocationSearchBarWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _textEditingController.text.isEmpty ? 350 : 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Color.fromARGB(255, 240, 240, 240), // Background color
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        width: 65,
                        child: Text('End'),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 50,
                        child: TextFormField(
                          controller: _textEditingController,
                          focusNode: _endLocationFocusNode,
                          decoration: InputDecoration(
                              hintText: 'Tap to search',
                              hintStyle: TextStyle(
                                  color: Colors.grey, // Set the hint text color
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13),
                              border: InputBorder.none),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.my_location_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.all(0))),
                        ),
                      ),
                    ],
                  ),
                ),
                _textEditingController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _startLocationTextEditingController.text = '';
                            },
                            child: Icon(Icons.arrow_back_sharp),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey[900],
                                onPrimary: Colors.white,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 40)),
                          ),
                        ))
                    : Container(),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _textEditingController.text.isNotEmpty
                  ? _containerHeight / 1.75
                  : 0,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height *
                          0.06, // Specify the desired height
                      width:
                          MediaQuery.of(context).size.width, // Use full width
                      child: ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              places[index]['description']);
                          print(locations.last.longitude);
                          print(locations.last.latitude);
                        },
                        leading: Icon(Icons.location_on),
                        title: Text(
                          places[index]['description'],
                          overflow: TextOverflow
                              .ellipsis, // Use ellipsis to indicate truncation
                          maxLines: 1,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget CreateRouteTitleAndButtonWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                _textEditingController.text.isEmpty
                    ? 'Create a route'
                    : 'Search maps',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
              ),
              Container(
                  height: 45,
                  width: 70,
                  child: createRoute
                      ? ElevatedButton(
                          onPressed: () {
                            _textEditingController.text = '';
                            setState(() {
                              createRoute = false;
                            });
                          },
                          child: Icon(Icons.arrow_back_sharp),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey[900],
                              onPrimary: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 40)),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              createRoute = true;
                            });
                          },
                          child: Icon(Icons.add, color: Colors.white, size: 35),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 78, 199, 82),
                            padding: EdgeInsets.zero,
                          ))),
            ],
          )),
    );
  }

  Widget CreateRouteLocationSearchWidget() {
    return Column(
      children: [
        CreateRouteTitleAndButtonWidget(),
        showStart ? StartLocationSearchBarWidget() : Container(),
        showEnd ? EndLocationSearchBarWidget() : Container(),
      ],
    );
  }

  Widget CreateRouteInitialWidget() {
    return Column(
      children: [CreateRouteTitleAndButtonWidget(), SearchBarWidget()],
    );
  }

  Widget CreateRouteWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: MediaQuery.of(context).size.width,
        height: _containerHeight,
        decoration: BoxDecoration(
          color: Colors.white, // Background color for visibility
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -2),
              blurRadius: 1,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createRoute
                ? CreateRouteLocationSearchWidget()
                : CreateRouteInitialWidget()
          ],
        ),
      ),
    );
  }

  void _onFocusChange() {
    setState(() {
      _isEditingSearchLocation = _mapSearchFocusNode.hasFocus;
      _isEditingStartLocation = _startLocationFocusNode.hasFocus;
      _isEditingEndLocation = _endLocationFocusNode.hasFocus;
      updateContainerHeight();
      updateStartEndSearch();
      print(showStart);
      print(showEnd);
    });
  }

  @override
  void initState() {
    super.initState();
    _mapSearchFocusNode.addListener(_onFocusChange);
    _startLocationFocusNode.addListener(_onFocusChange);
    _endLocationFocusNode.addListener(_onFocusChange);

    _textEditingController.addListener(() {
      onModify();
    });
    packData();
  }

  @override
  void dispose() {
    _isDisposed = true; // Set the disposed flag to true
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [MapWidget(), CreateRouteWidget()],
      ),
    ));
  }
}
