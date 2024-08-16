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
                    polylines: viewModel.polyines,
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

  Widget RouteWidget(BuildContext context) {
    return Consumer<RoutePlannerViewModel>(
        builder: (context, viewModel, child) {
      return Expanded(
        child: Stack(
          children: [
            if (viewModel.startSelected && viewModel.destinationSelected)
              Positioned(
                bottom: 90,
                left: 20,
                child: Container(
                  width: 350,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.getRoute();
                    },
                    child: Text('Calculate route'),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.green,
                        foregroundColor: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
