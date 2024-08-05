import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile {
  String pid;
  String name;
  DateTime dob;
  Color color;

  Profile({
    required this.pid,
    required this.name,
    required this.dob,
    required this.color,
  });

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    return Profile(
      pid: doc.id,
      name: doc['name'] ?? '',
      color: Color(doc['color'] ?? 0xFF000000),
      dob: (doc['dob'] as Timestamp).toDate(),
    );
  }
}
