import 'package:flutter/material.dart';
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
                YourListWidget(),
              ],
            ),
          ),
        ),
      ],
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
            primary: Colors.green,
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
                  primary: Colors.green,
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
    );
  }

  Widget YourListWidget() {
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
                return ListItem(location, context);
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
          markers: Set<Marker>.of(viewModel.markers),
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
                                primary: Colors.grey[900],
                                onPrimary: Colors.white,
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
            primary: Colors.green,
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

  Widget YourListWidget() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Consumer<DreamListViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              itemCount: viewModel.locations.length,
              itemBuilder: (context, index) {
                final location = viewModel.locations[index];
                return ListItem(location, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget ListItem(DreamListLocation location, BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
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
                              primary: Colors.grey[900],
                              onPrimary: Colors.white,
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
                          primary: Colors.green,
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
                YourListWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
