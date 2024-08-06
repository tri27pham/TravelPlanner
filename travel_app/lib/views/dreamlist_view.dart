import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dreamlist_viewmodel.dart'; // Import the ViewModel

class BucketList extends StatelessWidget {
  const BucketList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DreamListViewModel(),
      child: Scaffold(
        body: Consumer<DreamListViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.showList ? ListViewContent() : MapViewContent();
          },
        ),
      ),
    );
  }
}

class ListViewContent extends StatelessWidget {
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
                  padding: EdgeInsets.fromLTRB(30, 40, 0, 10),
                  child: Text(
                    'Dream List',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                  ),
                ),
                SearchBarWidget(),
                YourListAndMapViewWidget(context),
                YourListWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget YourListAndMapViewWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 25, 40, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your list',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          Container(
            height: 25,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Provider.of<DreamListViewModel>(context, listen: false)
                    .toggleView();
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
        ],
      ),
    );
  }

  Widget ListItem(item, BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Container(
          height: 90,
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ClipRect(
                        child: Container(
                          width: 105,
                          child: Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ClipRect(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            width: 100,
                            child: Text(
                              item.location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Added on: ${item.dateAdded}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Added by: ${item.addedBy}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
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
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return ListItem(item, context);
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
          markers: Set<Marker>.of(viewModel.myMarker),
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
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
                                viewModel.toggleView();
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
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 0, 12),
      child: Container(
        height: 25,
        width: 150,
        child: ElevatedButton(
          onPressed: () {
            Provider.of<DreamListViewModel>(context, listen: false)
                .toggleView();
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
