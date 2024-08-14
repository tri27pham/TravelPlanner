import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/AppState.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import '../models/profile_model.dart';
import '../models/dreamlist_location.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'dart:convert';

class DbService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String colorToHex(Color color, {bool includeAlpha = false}) {
    String hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return includeAlpha ? '#$hex' : '${hex.substring(2)}';
  }

  Future<void> addProfile(BuildContext context,
      {String? name, Color? color, DateTime? dateOfBirth}) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.account != null && appState.account!.email.isNotEmpty) {
      String uid = appState.account!.uid;

      try {
        Map<String, dynamic> profileData = {
          "name": name ?? appState.account!.email,
          "color": colorToHex(color!) ?? "ffffff",
          "dob": Timestamp.fromDate(dateOfBirth!) ?? DateTime.now(),
        };

        CollectionReference collectionRef =
            firestore.collection('accounts').doc(uid).collection('profiles');

        String profileID = collectionRef.doc().id;

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
            addedBy: addedBy));
      }
      log('length ${locations.length.toString()}');
      return locations;
    } catch (e) {
      log("Error fetching locations: $e");
      return [];
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
}
