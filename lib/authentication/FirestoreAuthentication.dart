import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class FirestoreAuthentication {
  FirestoreUser? firestoreUser;

  FirestoreAuthentication._privateConstructor();

  static final FirestoreAuthentication _instance = FirestoreAuthentication._privateConstructor();

  static FirestoreAuthentication get instance => _instance;

}

