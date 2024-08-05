import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/AppState.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class DbService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<void> createAccount(BuildContext context) async {}

  // Future<void> addProfile(BuildContext context, String? name) async {
  //   final appState = Provider.of<AppState>(context, listen: false);

  //   if (appState.account != null && appState.account!.email.isNotEmpty) {
  //     try {
  //       String uid = appState.account!.uid;

  //       Map<String, dynamic> profileData = {
  //         "name": name ?? appState.account!.email,
  //       };

  //       DocumentReference docRef = firestore
  //           .collection('accounts')
  //           .doc(uid)
  //           .collection('profiles')
  //           .doc(name);

  //       await docRef.set(profileData);
  //     } catch (e) {
  //       log("Error adding profile: $e");
  //     }
  //   } else {
  //     log("Account is null or email is empty");
  //   }
  // }

  Future<void> addProfile(BuildContext context, {String? name}) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.account != null && appState.account!.email.isNotEmpty) {
      String uid = appState.account!.uid;

      try {
        Map<String, dynamic> profileData = {
          "name": name ?? appState.account!.email,
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
          "name": appState.account!.email,
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
      log("Error fetching profiles: $e");
      return [];
    }
  }
}
