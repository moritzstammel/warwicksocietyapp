import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class FirestoreAuthentication {
  FirestoreUser? firestoreUser;

  FirestoreAuthentication._privateConstructor();

  static final FirestoreAuthentication _instance = FirestoreAuthentication._privateConstructor();

  static FirestoreAuthentication get instance => _instance;

  Future<void> followSociety(SocietyInfo society) async {
    if(firestoreUser == null) return;

    final DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${firestoreUser!.id}");
    final user = firestoreUser!;
    final batch = FirebaseFirestore.instance.batch();

    batch.update(userRef, {
      "followed_societies" : FieldValue.arrayUnion([society.toJson()])
    });

    Map<String,dynamic> updatedChatUsers = {
      'users.${user.id}': {
        "full_name": user.fullName,
        "image_url": user.imageUrl,
        "ref" : FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${user.id}"),
        "active" : true,
        "username" : user.username,
        "fcm_token": user.fcmToken,
      }
    };
    if (society.chatRef != null){
      batch.update(society.chatRef!, updatedChatUsers);
    }

    await batch.commit();
  }
  Future<void> unfollowSociety(SocietyInfo society) async {
    if(firestoreUser == null) return;

    final DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${firestoreUser!.id}");
    final user = firestoreUser!;
    final batch = FirebaseFirestore.instance.batch();

    batch.update(userRef, {
      "followed_societies" : FieldValue.arrayRemove([society.toJson()])
    });

    Map<String,dynamic> updatedChatUsers = {
      'users.${user.id}': {
        "full_name": user.fullName,
        "image_url": user.imageUrl,
        "ref" : FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${user.id}"),
        "active" : false,
        "username" : user.username,
        "fcm_token": user.fcmToken,
      }
    };
    if (society.chatRef != null){
      batch.update(society.chatRef!, updatedChatUsers);
    }

    await batch.commit();
  }

}

