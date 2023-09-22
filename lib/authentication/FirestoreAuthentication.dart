import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class FirestoreAuthentication {
  FirestoreUser? firestoreUser;

  FirestoreAuthentication._privateConstructor();

  static final FirestoreAuthentication _instance = FirestoreAuthentication._privateConstructor();

  static FirestoreAuthentication get instance => _instance;

}

