import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart';

import 'package:provider/provider.dart';
import 'package:travel_app/models/predicted_route_place_model.dart';
import '../../viewmodels/route_viewmodel.dart';
import '../models/route_place.dart';
import 'dart:developer';

class RoutePlanner extends StatelessWidget {
  const RoutePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = RoutePlannerViewModel();
        viewModel.textEditingController
            .addListener(() => viewModel.onMainSearchModify());
        viewModel.startLocationTextEditingController
            .addListener(() => viewModel.onStartSearchModify());
        viewModel.endLocationTextEditingController
            .addListener(() => viewModel.onEndSearchModify());
        viewModel.mapSearchFocusNode
            .addListener(() => viewModel.onFocusChange());
        viewModel.startLocationFocusNode
            .addListener(() => viewModel.onFocusChange());
        viewModel.endLocationFocusNode
            .addListener(() => viewModel.onFocusChange());
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<RoutePlannerViewModel>(
          builder: (context, viewModel, child) {
            return GestureDetector(
              onTap: () {
                // FocusScope.of(context).unfocus();
                viewModel.resetControllersAndFocus();
              },
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: RoutePlannerViewModel.initPos,
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(viewModel.myMarker),
                    onMapCreated: (GoogleMapController controller) {
                      viewModel.mapController.complete(controller);
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: MediaQuery.of(context).size.width,
                      height: viewModel.containerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: CreateRouteInitialWidget(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget CreateRouteLocationSearchWidget(
      RoutePlannerViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        CreateRouteTitleWidget(viewModel),
        StartLocationSearchBarWidget(viewModel, context),
        EndLocationSearchBarWidget(viewModel, context)
      ],
    );
  }

  Widget CreateRouteInitialWidget(BuildContext context) {
    return Consumer<RoutePlannerViewModel>(
        builder: (context, viewModel, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateRouteTitleWidget(viewModel),
          viewModel.destinationSelected
              ? RouteWidget(context)
              : SearchBarWidget(viewModel, context)
        ],
      );
    });
  }

  Widget RouteWidget(BuildContext context) {
    return Consumer<RoutePlannerViewModel>(
        builder: (context, viewModel, child) {
      return Expanded(
        child: Stack(
          children: [
            Positioned(
              top: 55,
              left: 20,
              child: EndLocationSearchBarWidget(viewModel, context),
            ),
            Positioned(
              top: 0,
              left: 20,
              child: StartLocationSearchBarWidget(viewModel, context),
            ),
          ],
        ),
      );
    });
  }

  Widget CreateRouteTitleWidget(RoutePlannerViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a route',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchBarWidget(
      RoutePlannerViewModel viewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width:
                      viewModel.textEditingController.text.isEmpty ? 350 : 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.circular(25),
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
                          controller: viewModel.textEditingController,
                          focusNode: viewModel.mapSearchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search for a location',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                viewModel.textEditingController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.textEditingController.text = '';
                              viewModel.notifyListeners();
                            },
                            child: Icon(Icons.arrow_back_sharp),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[900],
                              onPrimary: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 40),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: viewModel.textEditingController.text.isNotEmpty
                  // viewModel.mapSearchFocusNode.hasFocus
                  ? viewModel.containerHeight / 1.75
                  : 0,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                itemCount: viewModel.places.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () async {
                        PredictedRoutePlace place = viewModel.places[index];
                        RoutePlace selectedPlace =
                            await viewModel.getRoutePlaceInfo(place.placeId);
                        viewModel.setInitialDestination(selectedPlace);
                      },
                      leading: Icon(Icons.location_on),
                      title: Text(
                        viewModel.places[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget StartLocationSearchBarWidget(
      RoutePlannerViewModel viewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Center(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 350,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(20),
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
                              controller:
                                  viewModel.startLocationTextEditingController,
                              focusNode: viewModel.startLocationFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Tap to search',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                              ),
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
                                  padding: EdgeInsets.all(0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height:
                    // viewModel.startLocationTextEditingController.text.isNotEmpty
                    viewModel.startLocationFocusNode.hasFocus
                        ? viewModel.containerHeight / 1.75
                        : 0,
                width: 350,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  itemCount: viewModel.startPlaces.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        onTap: () async {
                          // List<Location> locations = await locationFromAddress(
                          //     viewModel.startPlaces[index].description);
                          // viewModel.start = viewModel.startPlaces[index];
                          // viewModel.startLocationTextEditingController.text =
                          PredictedRoutePlace place =
                              viewModel.startPlaces[index];
                          RoutePlace selectedPlace =
                              await viewModel.getRoutePlaceInfo(place.placeId);
                          viewModel.setStart(selectedPlace);
                        },
                        leading: Icon(Icons.location_on),
                        title: Text(
                          viewModel.startPlaces[index].description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget EndLocationSearchBarWidget(
      RoutePlannerViewModel viewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(20),
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
                            controller:
                                viewModel.endLocationTextEditingController,
                            focusNode: viewModel.endLocationFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Tap to search',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                            ),
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
                                padding: EdgeInsets.all(0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height:
                  // viewModel.endLocationTextEditingController.text.isNotEmpty
                  viewModel.endLocationFocusNode.hasFocus
                      ? viewModel.containerHeight / 1.75
                      : 0,
              width: 350,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                itemCount: viewModel.endPlaces.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () async {
                        PredictedRoutePlace place = viewModel.endPlaces[index];
                        RoutePlace selectedPlace =
                            await viewModel.getRoutePlaceInfo(place.placeId);
                        viewModel.setDestination(selectedPlace);
                      },
                      leading: Icon(Icons.location_on),
                      title: Text(
                        viewModel.endPlaces[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
