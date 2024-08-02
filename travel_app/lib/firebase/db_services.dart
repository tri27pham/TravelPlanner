import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/AppState.dart';
import '../models/profile.dart';
import 'package:provider/provider.dart';

class DbService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addProfile(BuildContext context, String name) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.account != null && appState.account!.email.isNotEmpty) {
      try {
        String email = appState.account!.email;

        Map<String, dynamic> profileData = {
          "name": name,
        };

        DocumentReference docRef = firestore
            .collection('accounts')
            .doc(email)
            .collection('profiles')
            .doc(name);

        await docRef.set(profileData);
      } catch (e) {
        print("Error adding profile: $e");
      }
    } else {
      print("Account is null or email is empty");
    }
  }

  Future<List<String>> loadProfilesFromDb(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    try {
      // Reference to the profiles collection
      CollectionReference profilesCollection = firestore
          .collection('accounts')
          .doc(appState.account!.email)
          .collection('profiles');

      // Get all documents in the profiles collection
      QuerySnapshot querySnapshot = await profilesCollection.get();

      List<String> documentIds =
          querySnapshot.docs.map((doc) => doc.id).toList();

      return documentIds;

      // // Extract data from each document
      // List<Map<String, dynamic>> profiles = querySnapshot.docs.map((doc) {
      //   return doc.data() as Map<String, dynamic>;
      // }).toList();

      // return profiles;
    } catch (e) {
      print("Error fetching profiles: $e");
      return [];
    }
  }
}
