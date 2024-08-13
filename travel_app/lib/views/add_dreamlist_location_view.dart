// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/dreamlist_location.dart';
import '../viewmodels/dreamlist_location_viewmodel.dart';

import 'package:geocoding/geocoding.dart';
import 'dart:developer';

class AddDreamlistLocation extends StatelessWidget {
  const AddDreamlistLocation({super.key});

  void selectLocation(BuildContext context, DreamListLocation location) {
    final viewModel =
        Provider.of<DreamListLocationViewModel>(context, listen: false);
    viewModel.selectLocation(location);
  }

  Widget SearchBarWidget(BuildContext context) {
    // final viewModel = Provider.of<DreamListLocationViewModel>(context);
    return Consumer<DreamListLocationViewModel>(
        builder: (context, viewModel, child) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Center(
          child: viewModel.locationSelected
              ? Container()
              : Column(
                  children: [
                    Container(
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
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      height: viewModel.textEditingController.text.isEmpty
                          ? 0
                          : MediaQuery.of(context).size.width * 0.7,
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                                DreamListLocation dreamListLocation =
                                    await viewModel.getDreamlistLocationInfo(
                                        viewModel.places[index].placeId);
                                selectLocation(context, dreamListLocation);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      final viewModel = DreamListLocationViewModel();
      viewModel.textEditingController.addListener(() => viewModel.onModify());
      return viewModel;
    }, child: Consumer<DreamListLocationViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              viewModel.locationSelected
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.locationSelected = false;
                                log(viewModel.locationSelected.toString());
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
                                  Center(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viewModel.selectedLocation.name,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(viewModel
                                              .selectedLocation.locationName),
                                          Text(
                                              "${viewModel.selectedLocation.rating.toString()} (${viewModel.selectedLocation.numReviews.toString()})"),
                                          Text(viewModel
                                              .selectedLocation.description),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  viewModel.addLocationToDb(context);
                                },
                                child: Text('Add Location'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 40),
                                  elevation: 0,
                                  backgroundColor: viewModel.locationSelected
                                      ? Colors.green
                                      : Colors.transparent,
                                  foregroundColor: viewModel.locationSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                                'Cancel',
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
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SearchBarWidget(context),
                                    // TextFormField(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
            ],
          ),
        );
      },
    ));
  }
}
