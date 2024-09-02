import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/models/route.dart';
import 'package:travel_app/models/route_place.dart';
import '../models/AppState.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import '../models/profile_model.dart';
import '../models/dreamlist_location.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../models/route.dart';

class DbService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String colorToHex(Color color, {bool includeAlpha = false}) {
    String hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return includeAlpha ? '#$hex' : '${hex.substring(2)}';
  }

  Future<void> addProfile(BuildContext context, Profile profile) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.account != null && appState.account!.email.isNotEmpty) {
      String uid = appState.account!.uid;

      try {
        Map<String, dynamic> profileData = {
          "name": profile.name ?? appState.account!.email,
          "color": colorToHex(profile.color) ?? "ffffff",
          "dob": Timestamp.fromDate(profile.dob) ?? DateTime.now(),
        };

        CollectionReference collectionRef =
            firestore.collection('accounts').doc(uid).collection('profiles');

        // String profileID = collectionRef.doc().id;
        String profileID = profile.pid;

        DocumentReference docRef = collectionRef.doc(profileID);

        await docRef.set(profileData);
      } catch (e) {
        log("Error adding profile: $e");
      }
    } else {
      log("Account is null or email is empty");
    }
  }

  Future<void> createAccount(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    log(appState.account!.email);
    if (appState.account != null && appState.account!.email.isNotEmpty) {
      try {
        Map<String, dynamic> accountData = {
          "email": appState.account!.email,
        };

        CollectionReference collectionRef = firestore.collection('accounts');

        String uid = appState.account!.uid;

        await collectionRef.doc(uid).set(accountData);
      } catch (e) {
        log("Error adding profile: $e");
      }
    } else {
      log(appState.account.toString());
      log("Account is null or email is empty");
    }
  }

  List<GeoPoint> polylineToGeoPoints(Polyline polyline) {
    return polyline.points
        .map((LatLng point) => GeoPoint(point.latitude, point.longitude))
        .toList();
  }

  Polyline geoPointsToPolyline(List<dynamic> geoPointsList, String polylineId) {
    List<GeoPoint> geoPoints =
        geoPointsList.map((item) => item as GeoPoint).toList();
    List<LatLng> latLngPoints = geoPoints.map((geoPoint) {
      return LatLng(geoPoint.latitude, geoPoint.longitude);
    }).toList();

    return Polyline(
      polylineId: PolylineId(polylineId),
      points: latLngPoints,
      color: Colors.blue,
      width: 5,
    );
  }

  Future<void> addRoute(
      BuildContext context, RouteWithDreamlistLocations route) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.account != null && appState.account!.email.isNotEmpty) {
      String uid = appState.account!.uid;

      try {
        CollectionReference collectionRef =
            firestore.collection('accounts').doc(uid).collection('routes');

        String routeID = collectionRef.doc().id;

        DocumentReference docRef = collectionRef.doc(routeID);

        Map<String, dynamic> routeData = {
          "routeID": routeID,
          "polyline": polylineToGeoPoints(route.polyline),
          "origin": route.origin.toMap(),
          "destination": route.destination.toMap(),
          "directDistance": route.directDistance,
          "indirectDistance": route.indirectDistance,
          "distanceDifference": route.distanceDifference,
          "directTime": route.directTime,
          "indirectTime": route.indirectTime,
          "timeDifference": route.timeDifference
        };

        await docRef.set(routeData);

        collectionRef = docRef.collection('locationsOnRoute');

        for (DreamListLocation location in route.locationsOnRoute) {
          Map<String, dynamic> locationData = {
            "id": location.id,
            "name": location.name,
            "locationName": location.locationName,
            "coordinates": {
              "latitude": location.locationCoordinates.latitude,
              "longitude": location.locationCoordinates.longitude,
            },
            "description": location.description,
            "rating": location.rating,
            "numReviews": location.numReviews,
            "addedOn": location.addedOn,
            "addedBy": location.addedBy,
            "visited": location.visited
          };

          await collectionRef.doc(location.id).set(locationData);

          CollectionReference photosSubCollectionRef =
              collectionRef.doc(location.id).collection('photos');

          for (Uint8List image in location.imageDatas) {
            await photosSubCollectionRef.add({
              'imageData': base64Encode(image),
            });
          }
        }
        log('added');
      } catch (e) {
        log("Error adding profile: $e");
      }
    } else {
      log("Account is null or email is empty");
    }
  }

  Future<void> deleteRoute(
      BuildContext context, RouteWithDreamlistLocations route) async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      // Create a reference to the 'routes' collection for the user's account
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('accounts')
          .doc(appState.account!.uid)
          .collection('routes');

      // Delete the document with the given route ID
      await collectionRef
          .doc(route.id) // Use the route's ID to locate the document
          .delete();

      print("Document deleted successfully.");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  Future<List<RouteWithDreamlistLocations>> loadRoutesFromDb(
      BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    List<RouteWithDreamlistLocations> routes = [];

    try {
      CollectionReference routesCollection = firestore
          .collection('accounts')
          .doc(appState.account!.uid)
          .collection('routes');

      QuerySnapshot querySnapshot = await routesCollection.get();

      for (var doc in querySnapshot.docs) {
        // log(doc['polyline'].toString());
        String routeID = doc.id;
        Polyline polyline = geoPointsToPolyline(doc['polyline'], routeID);
        RoutePlace origin = RoutePlace(
            placeId: doc['origin']['placeId'],
            name: doc['origin']['name'],
            coordinates: LatLng(doc['origin']['coordinates']['latitude'],
                doc['origin']['coordinates']['longitude']));
        RoutePlace destination = RoutePlace(
            placeId: doc['destination']['placeId'],
            name: doc['destination']['name'],
            coordinates: LatLng(doc['destination']['coordinates']['latitude'],
                doc['destination']['coordinates']['longitude']));

        int directDistance = doc['directDistance'];
        int indirectDistance = doc['indirectDistance'];
        int distanceDifference = doc['distanceDifference'];
        String directTime = doc['directTime'];
        String indirectTime = doc['indirectTime'];
        String timeDifference = doc['timeDifference'];

        CollectionReference locationsOnRouteRef =
            routesCollection.doc(routeID).collection('locationsOnRoute');

        QuerySnapshot locationsOnRouteDocs =
            await locationsOnRouteRef.limit(1).get();

        List<DreamListLocation> locations = [];

        if (locationsOnRouteDocs.docs.isNotEmpty) {
          QuerySnapshot locationsOnRoute = await locationsOnRouteRef.get();

          for (var location in locationsOnRoute.docs) {
            String id = location.id;
            String name = location['name'];
            String locationName = location['locationName'];
            LatLng locationCoordinates = LatLng(
                location['coordinates']['latitude'],
                location['coordinates']['longitude']);
            String description = location['description'];
            double rating = location['rating'];
            int numReviews = location['numReviews'];
            String addedOn = location['addedOn'];
            String addedBy = location['addedBy'];
            bool visited = location['visited'];

            QuerySnapshot querySnapshotPhotos =
                await locationsOnRouteRef.doc(id).collection('photos').get();

            List<Uint8List> imageDatas = [];

            for (var photoDoc in querySnapshotPhotos.docs) {
              imageDatas.add(base64Decode(photoDoc['imageData']));
            }

            locations.add(DreamListLocation(
                id: id,
                name: name,
                locationName: locationName,
                locationCoordinates: locationCoordinates,
                description: description,
                rating: rating,
                numReviews: numReviews,
                imageDatas: imageDatas,
                photoRefs: [],
                addedOn: addedOn,
                addedBy: addedBy,
                visited: visited));
          }
        }

        routes.add(RouteWithDreamlistLocations(
            id: routeID,
            polyline: polyline,
            origin: origin,
            destination: destination,
            locationsOnRoute: locations,
            directDistance: directDistance,
            indirectDistance: indirectDistance,
            distanceDifference: distanceDifference,
            directTime: directTime,
            indirectTime: indirectTime,
            timeDifference: timeDifference));
      }

      log(routes.first.directDistance.toString());

      return routes;
    } catch (e) {
      log("Error fetching routes: $e");
      return [];
    }
  }

  int hexToInt(String hexString) {
    // Prepend 'FF' for full opacity if the hex string is in RGB format (6 characters)
    final buffer = StringBuffer();
    if (hexString.length == 6) {
      buffer.write('ff'); // Add 'ff' for full opacity
    }
    buffer.write(hexString);

    // Parse the string as a base-16 (hex) integer
    return int.parse(buffer.toString(), radix: 16);
  }

  Future<List<Profile>> loadProfilesFromDb(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    List<Profile> profiles = [];

    try {
      CollectionReference profilesCollection = firestore
          .collection('accounts')
          .doc(appState.account!.uid)
          .collection('profiles');

      QuerySnapshot querySnapshot = await profilesCollection.get();

      querySnapshot.docs.forEach((doc) {
        String pid = doc.id;
        String name = doc["name"];
        Timestamp dobTimestamp = doc["dob"];
        DateTime dob = dobTimestamp.toDate();
        String colorVal = doc["color"] ?? "0xFF000000";
        Color color = Color(hexToInt(colorVal));

        profiles.add(Profile(pid: pid, name: name, dob: dob, color: color));
      });
      return profiles;
    } catch (e) {
      log("Error fetching profiles: $e");
      return [];
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    String formattedDate =
        DateFormat('dd/MM/yy').format(dateTime); // Format DateTime to String
    return formattedDate;
  }

  Future<List<DreamListLocation>> loadDreamlistFromDb(
      BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    List<DreamListLocation> locations = [];

    try {
      CollectionReference dreamlistCollection = firestore
          .collection('accounts')
          .doc(appState.account!.uid)
          .collection('dreamlist');

      QuerySnapshot querySnapshot = await dreamlistCollection.get();

      for (var doc in querySnapshot.docs) {
        String id = doc.id;
        String name = doc['name'];
        String locationName = doc['locationName'];
        LatLng locationCoordinates = LatLng(doc['latitude'], doc['longitude']);
        String description = doc['description'];
        double rating = doc['rating'];
        int numReviews = doc['numReviews'];
        String addedOn = formatTimestamp(doc['addedOn']);
        String addedBy = doc['addedBy'];
        bool visited = doc['visited'];

        QuerySnapshot querySnapshotPhotos =
            await dreamlistCollection.doc(id).collection('photos').get();

        List<Uint8List> imageDatas = [];

        for (var photoDoc in querySnapshotPhotos.docs) {
          imageDatas.add(base64Decode(photoDoc['imageData']));
        }

        locations.add(DreamListLocation(
            id: id,
            name: name,
            locationName: locationName,
            locationCoordinates: locationCoordinates,
            description: description,
            rating: rating,
            numReviews: numReviews,
            imageDatas: imageDatas,
            photoRefs: [],
            addedOn: addedOn,
            addedBy: addedBy,
            visited: visited));
      }
      return locations;
    } catch (e) {
      log("Error fetching locations: $e");
      return [];
    }
  }

  Future<void> deleteDreamListLocation(
      BuildContext context, DreamListLocation location) async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      // Reference to the 'dreamlist' collection for the user's account
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('accounts')
          .doc(appState.account!.uid)
          .collection('dreamlist')
          .doc(location.id);

      // Step 1: Delete all subcollections of the document
      await deleteSubcollections(docRef);

      // Step 2: Delete the parent document
      await docRef.delete();

      print("Document and its subcollections deleted successfully.");
    } catch (e) {
      print("Error deleting document and subcollections: $e");
    }
  }

  Future<void> deleteSubcollections(DocumentReference docRef) async {
    try {
      // Get all subcollections of the document
      final subcollections = await docRef.collection('photos').get();

      // Iterate over each subcollection
      for (var subcollection in subcollections.docs) {
        // Get the reference of each document in the subcollection
        final subDocRef = docRef.collection(subcollection.reference.parent.id);

        // Get all documents in this subcollection
        final subDocSnapshot = await subDocRef.get();

        // Delete each document in the subcollection
        for (var doc in subDocSnapshot.docs) {
          log(doc.id);
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print("Error deleting subcollections: $e");
    }
  }

  Future<void> addBucketListLocation(BuildContext context,
      DreamListLocation location, List<Uint8List> images) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.account != null && appState.account!.email.isNotEmpty) {
      String uid = appState.account!.uid;

      try {
        Map<String, dynamic> locationData = {
          "id": location.id,
          "name": location.name,
          "locationName": location.locationName,
          "latitude": location.locationCoordinates.latitude,
          "longitude": location.locationCoordinates.longitude,
          "description": location.description,
          "rating": location.rating,
          "numReviews": location.numReviews,
          "addedOn": DateTime.now(),
          "addedBy": appState.profile!.name,
          "visited": false,
        };

        CollectionReference collectionRef =
            firestore.collection('accounts').doc(uid).collection('dreamlist');

        String locationID = collectionRef.doc().id;

        DocumentReference docRef = collectionRef.doc(locationID);

        await docRef.set(locationData);

        CollectionReference postsSubcollection =
            collectionRef.doc(locationID).collection('photos');

        // Loop through the list of strings and add each as a document
        for (Uint8List image in images) {
          await postsSubcollection.add({
            'imageData': base64Encode(image),
          });
        }
      } catch (e) {
        log("Error adding location: $e");
      }
    } else {
      log("Account is null or email is empty");
    }
  }

  Future<void> updateDreamlistLocation(
      BuildContext context, DreamListLocation location) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Specify the collection and document you want to update
    final DocumentReference documentRef = firestore
        .collection('accounts')
        .doc(appState.account!.uid)
        .collection('dreamlist')
        .doc(location.id);

    // Update a specific field in the document
    try {
      await documentRef.update({'visited': location.visited});
      print('Document field updated successfully');
    } catch (e) {
      print('Error updating document field: $e');
    }
  }
}
