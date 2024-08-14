import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart';

import 'package:provider/provider.dart';
import '../../viewmodels/route_viewmodel.dart';

class RoutePlanner extends StatelessWidget {
  const RoutePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = RoutePlannerViewModel();
        viewModel.textEditingController.addListener(() => viewModel.onModify());
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
                FocusScope.of(context).unfocus();
                // viewModel.startLocationTextEditingController.clear();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          viewModel.createRoute
                              ? CreateRouteLocationSearchWidget(
                                  viewModel, context)
                              : CreateRouteInitialWidget(viewModel, context),
                        ],
                      ),
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
        CreateRouteTitleAndButtonWidget(viewModel),
        viewModel.showStart
            ? StartLocationSearchBarWidget(viewModel, context)
            : Container(),
        viewModel.showEnd
            ? EndLocationSearchBarWidget(viewModel, context)
            : Container(),
      ],
    );
  }

  Widget CreateRouteInitialWidget(
      RoutePlannerViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        CreateRouteTitleAndButtonWidget(viewModel),
        SearchBarWidget(viewModel, context),
      ],
    );
  }

  Widget CreateRouteTitleAndButtonWidget(RoutePlannerViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Create a route',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
            ),
            Container(
              height: 45,
              width: 70,
              child: viewModel.createRoute
                  ? ElevatedButton(
                      onPressed: () {
                        viewModel.textEditingController.text = '';
                        viewModel.createRoute = false;
                        viewModel.notifyListeners();
                      },
                      child: Icon(Icons.arrow_back_sharp),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[900],
                        onPrimary: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 40),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        viewModel.createRoute = true;
                        viewModel.notifyListeners();
                      },
                      child: Icon(Icons.add, color: Colors.white, size: 35),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 78, 199, 82),
                        padding: EdgeInsets.zero,
                      ),
                    ),
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
                        List<Location> locations = await locationFromAddress(
                            viewModel.places[index].description);
                        print(locations.last.longitude);
                        print(locations.last.latitude);
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
                            controller: viewModel.textEditingController,
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
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: viewModel.textEditingController.text.isNotEmpty
                  ? viewModel.containerHeight / 1.75
                  : 0,
              width: 350,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                itemCount: viewModel.places.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(
                            viewModel.places[index].description);
                        print(locations.last.longitude);
                        print(locations.last.latitude);
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

  Widget EndLocationSearchBarWidget(
      RoutePlannerViewModel viewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
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
                          controller: viewModel.textEditingController,
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
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: viewModel.textEditingController.text.isNotEmpty
                  ? viewModel.containerHeight / 1.75
                  : 0,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView.builder(
                itemCount: viewModel.places.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(
                            viewModel.places[index].description);
                        print(locations.last.longitude);
                        print(locations.last.latitude);
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
}
