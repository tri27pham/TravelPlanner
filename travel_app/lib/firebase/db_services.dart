import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/AppState.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import '../models/profile_model.dart';

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
}
