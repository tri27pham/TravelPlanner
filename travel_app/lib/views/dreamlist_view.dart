import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dreamlist_viewmodel.dart';
import 'add_dreamlist_location_view.dart';
import '../models/dreamlist_location.dart';
import 'dart:developer';

class BucketList extends StatelessWidget {
  const BucketList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DreamListViewModel(),
      child: Scaffold(
        body: Consumer<DreamListViewModel>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
              future: viewModel.loadLocations(
                  context), // Call loadLocations before displaying content
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // if (!viewModel.locationsLoaded) {
                  // While waiting for the future to complete, show a loading indicator
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there was an error, show an error message
                  return Center(
                      child: Text('Error loading data: ${snapshot.error}'));
                } else {
                  // Once the future is complete, show the actual content
                  final pageWidgets = {
                    1: ListViewContent(),
                    2: MapViewContent(),
                    3: BucketListListView(),
                  };
                  return pageWidgets[viewModel.page] ??
                      Center(
                        child: Text('Page not found'),
                      );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class ListViewContent extends StatelessWidget {
  void showBucketListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BucketListListView();
      },
    );
  }

  void showLocationInfo(BuildContext context, DreamListLocation location) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: locationInfoPopUp(context, location),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  Widget locationInfoPopUp(BuildContext context, DreamListLocation location) {
    return ChangeNotifierProvider<DreamListLocation>.value(
      value: location,
      child: ChangeNotifierProvider<DreamListViewModel>(
        create: (_) => DreamListViewModel(),
        builder: (context, child) {
          final viewModel =
              Provider.of<DreamListViewModel>(context, listen: false);

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      foregroundColor: Colors.grey[700],
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<DreamListLocation>(
                          builder: (context, location, child) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                  width: 250,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      location.toggleVisited();
                                    },
                                    child: Text(
                                      location.visited
                                          ? 'VISITED'
                                          : 'NOT VISITED',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: location.visited
                                          ? Colors.green
                                          : Colors.grey,
                                      foregroundColor: location.visited
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Container(
                            width: 250,
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: location.imageDatas.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 2, right: 2),
                                  child: Container(
                                    width: 200,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        image: MemoryImage(
                                            location.imageDatas[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                location.locationName,
                                style: TextStyle(fontSize: 15),
                              ),
                              Row(
                                children: [
                                  Text('${location.rating.toString()}'),
                                  Icon(Icons.star_border_rounded),
                                  Text('(${location.numReviews.toString()})'),
                                ],
                              ),
                              Text(location.description),
                              Text('Added by: ${location.addedBy}'),
                              Text('Added on: ${location.addedOn}'),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 30),
                                child: Container(
                                  height: 40,
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await viewModel.updateDreamlistLocation(
                                          context, location);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Update location'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await viewModel.deleteDreamlistLocation(
                                        context, location);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete location'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
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
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -35,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/grandcanyon.png',
            fit: BoxFit.fitWidth,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60.0),
                topRight: Radius.circular(60.0),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
                  child: Text(
                    'Dream List',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                  ),
                ),
                switchToMapViewWidget(context),
                SearchBarWidget(),
                ListTitleAndEditListWidget(context),
                FilterListWidget(context),
                YourListWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget FilterListWidget(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);

    // Determine if the first or second button is selected
    // bool isFirstSelected = viewModel.segmentSelected.contains('0');
    // bool isSecondSelected = viewModel.segmentSelected.contains('1');

    return Center(
      child: Container(
        height: 30, // Adjust the height as needed
        width: double.infinity, // Make it take the full available width
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: ToggleButtons(
            isSelected: [
              !viewModel.viewVisited,
              viewModel.viewVisited
            ], // Update based on viewModel.viewVisited
            onPressed: (int index) {
              if (index == 0) {
                viewModel.updateSegmentSelected(
                    false); // Set viewVisited to false for "Not Visited"
              } else {
                viewModel.updateSegmentSelected(
                    true); // Set viewVisited to true for "Visited"
              }
            },
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.black, // Text color when not selected
            selectedColor: Colors.white, // Text color when selected
            fillColor: Colors.green, // Background color when selected
            renderBorder: false, // Remove the border
            constraints: BoxConstraints.expand(
              width: 155,
            ),
            children: [
              Container(
                color: !viewModel.viewVisited
                    ? Colors.green
                    : Colors.grey.shade300,
                alignment: Alignment.center,
                child: Text('Not Visited', textAlign: TextAlign.center),
              ),
              Container(
                color:
                    viewModel.viewVisited ? Colors.green : Colors.grey.shade300,
                alignment: Alignment.center,
                child: Text('Visited', textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget switchToMapViewWidget(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 0, 10),
      child: Container(
        height: 25,
        width: 150,
        child: ElevatedButton(
          onPressed: () {
            viewModel.setPage(2);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(0),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(
                    'Switch to map view',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.map_outlined,
                  size: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ListTitleAndEditListWidget(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your list',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 0, 10),
            child: Container(
              height: 25,
              width: 90,
              child: ElevatedButton(
                onPressed: () {
                  viewModel.setPage(3);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.all(0),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          'Edit list',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.mode_edit_outline_outlined,
                        size: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ListItem(DreamListLocation location, BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: GestureDetector(
          onTap: () {
            showLocationInfo(context, location);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(location.imageDatas.first),
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: Text(
                          location.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ClipRRect(
                        child: Text(
                          location.locationName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        'Added on: ${location.addedOn}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Added by: ${location.addedBy}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget YourListWidget() {
    return Container(
      height: 200,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Consumer<DreamListViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: viewModel.viewVisited
                  ? viewModel.visitedLocations.length
                  : viewModel.notVisitedLocations.length,
              itemBuilder: (context, index) {
                if (viewModel.viewVisited) {
                  final location = viewModel.visitedLocations[index];
                  return ListItem(location, context);
                } else {
                  final location = viewModel.notVisitedLocations[index];
                  return ListItem(location, context);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget SearchBarWidget() {
    return Center(
      child: Container(
        width: 320,
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
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a location or search by image',
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
    );
  }
}

class MapViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: DreamListViewModel.initPos,
          mapType: MapType.normal,
          markers: Set<Marker>.of(viewModel.createMarkers(context)),
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            log(viewModel.markers.length.toString());
            if (!viewModel.mapController.isCompleted) {
              viewModel.mapController.complete(controller);
            }
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 1,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Dream List',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            height: 45,
                            width: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.setPage(1);
                              },
                              child: Icon(Icons.arrow_back_sharp),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[900],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SwitchToListViewWidget(context),
                  SearchBarWidget(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget SwitchToListViewWidget(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 0, 12),
      child: Container(
        height: 25,
        width: 150,
        child: ElevatedButton(
          onPressed: () {
            viewModel.setPage(1);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(0),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(
                    'Switch to list view',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.list,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SearchBarWidget() {
    return Center(
      child: Container(
        width: 320,
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
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a location or search by image',
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
    );
  }
}

class BucketListListView extends StatelessWidget {
  const BucketListListView({super.key});

  Widget locationInfoPopUp(BuildContext context, DreamListLocation location) {
    return ChangeNotifierProvider<DreamListLocation>.value(
      value: location,
      child: ChangeNotifierProvider<DreamListViewModel>(
        create: (_) => DreamListViewModel(),
        builder: (context, child) {
          final viewModel =
              Provider.of<DreamListViewModel>(context, listen: false);

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      foregroundColor: Colors.grey[700],
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<DreamListLocation>(
                          builder: (context, location, child) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                  width: 250,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      location.toggleVisited();
                                    },
                                    child: Text(
                                      location.visited
                                          ? 'VISITED'
                                          : 'NOT VISITED',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: location.visited
                                          ? Colors.green
                                          : Colors.grey,
                                      foregroundColor: location.visited
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Container(
                            width: 250,
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: location.imageDatas.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 2, right: 2),
                                  child: Container(
                                    width: 200,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        image: MemoryImage(
                                            location.imageDatas[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                location.locationName,
                                style: TextStyle(fontSize: 15),
                              ),
                              Row(
                                children: [
                                  Text('${location.rating.toString()}'),
                                  Icon(Icons.star_border_rounded),
                                  Text('(${location.numReviews.toString()})'),
                                ],
                              ),
                              Text(location.description),
                              Text('Added by: ${location.addedBy}'),
                              Text('Added on: ${location.addedOn}'),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 30),
                                child: Container(
                                  height: 40,
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await viewModel.updateDreamlistLocation(
                                          context, location);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Update location'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await viewModel.deleteDreamlistLocation(
                                        context, location);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete location'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
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
              ],
            ),
          );
        },
      ),
    );
  }

  void showAddLocation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddDreamlistLocation(),
        );
      },
    );
  }

  void showLocationInfo(BuildContext context, DreamListLocation location) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: locationInfoPopUp(context, location),
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  Widget EditYourListWidget() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
        child: Consumer<DreamListViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              itemCount: viewModel.locations.length,
              itemBuilder: (context, index) {
                final location = viewModel.locations[index];
                return EditListItem(location, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget EditListItem(DreamListLocation location, BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
          child: GestureDetector(
            onTap: () {
              showLocationInfo(context, location);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.13,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(location.imageDatas.first),
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          child: Text(
                            location.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ClipRRect(
                          child: Text(
                            location.locationName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          'Added on: ${location.addedOn}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Added by: ${location.addedBy}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DreamListViewModel>(context);

    return Stack(
      children: [
        Positioned(
          top: -35,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/grandcanyon.png',
            fit: BoxFit.fitWidth,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60.0),
                topRight: Radius.circular(60.0),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.setPage(1);
                            },
                            child: Icon(Icons.arrow_back_sharp),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(35, 35),
                            ),
                          ),
                        ),
                        Text(
                          'Edit List',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Center(
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          showAddLocation(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.all(0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Text(
                                    'Add a location',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Icon(
                                  Icons.add_location_alt_outlined,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                EditYourListWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
