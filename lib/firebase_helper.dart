import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/models/event.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:warwicksocietyapp/models/society_info.dart';
import 'package:warwicksocietyapp/models/spotlight.dart';
import 'package:warwicksocietyapp/notification_helper.dart';

class FirestoreHelper {

  FirestoreHelper._privateConstructor();

  static final FirestoreHelper _instance = FirestoreHelper._privateConstructor();

  static FirestoreHelper get instance => _instance;

  Future<void> signUpForEvent(Event event) async {
    _changeSignUpState(event, true);
    NotificationScheduler.instance.addReminderForEvent(event);
  }
  Future<void> signOutForEvent(Event event) async {
    _changeSignUpState(event, false);
    NotificationScheduler.instance.removeReminderForEvent(event);
  }

  Future<void> _changeSignUpState(Event event,bool newState) async {
    final user = FirestoreAuthentication.instance.firestoreUser!;
    DocumentReference eventRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/events/${event.id}");
    DocumentReference chatRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/chats/${event.id}");

    Map<String,dynamic> updatedEventUsers = {
      'registered_users.${user.id}': {
        "full_name": user.fullName,
        "image_url": user.imageUrl,
        "ref" : FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${user.id}"),
        "active" : newState,
        "username" : user.username,
        "fcm_token": user.fcmToken,
      }
    };

    Map<String,dynamic> updatedChatUsers = {
      'users.${user.id}': {
        "full_name": user.fullName,
        "image_url": user.imageUrl,
        "ref" : FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${user.id}"),
        "active" : newState,
        "chat_muted" : false,
        "username" : user.username,
        "fcm_token": user.fcmToken,
      }
    };

    final batch = FirebaseFirestore.instance.batch();
    batch.update(eventRef, updatedEventUsers);
    batch.update(chatRef, updatedChatUsers);
    await batch.commit();
  }

  Future<void> followSociety(SocietyInfo society) async {
    FirestoreUser firestoreUser = FirestoreAuthentication.instance.firestoreUser!;

    final DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${firestoreUser.id}");
    final batch = FirebaseFirestore.instance.batch();

    batch.update(userRef, {
      "followed_societies" : FieldValue.arrayUnion([society.toJson()])
    });

    Map<String,dynamic> updatedChatUsers = {
      'users.${firestoreUser.id}': {
        "full_name": firestoreUser.fullName,
        "image_url": firestoreUser.imageUrl,
        "ref" : FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${firestoreUser.id}"),
        "active" : true,
        "username" : firestoreUser.username,
        "fcm_token": firestoreUser.fcmToken,
      }
    };
    if (society.chatRef != null){
      batch.update(society.chatRef!, updatedChatUsers);
    }

    await batch.commit();
  }
  Future<void> unfollowSociety(SocietyInfo society) async {
    FirestoreUser firestoreUser = FirestoreAuthentication.instance.firestoreUser!;

    final DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${firestoreUser.id}");
    final batch = FirebaseFirestore.instance.batch();

    batch.update(userRef, {
      "followed_societies" : FieldValue.arrayRemove([society.toJson()])
    });

    Map<String,dynamic> updatedChatUsers = {
      'users.${firestoreUser.id}': {
        "full_name": firestoreUser.fullName,
        "image_url": firestoreUser.imageUrl,
        "ref" : FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${firestoreUser.id}"),
        "active" : false,
        "username" : firestoreUser.username,
        "fcm_token": firestoreUser.fcmToken,
      }
    };
    if (society.chatRef != null){
      batch.update(society.chatRef!, updatedChatUsers);
    }

    await batch.commit();
  }

  void createSpotlight(Spotlight newSpotlight) => FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("spotlights").add(newSpotlight.toJson());
  void updateSpotlight(Spotlight updatedSpotlight) => FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("spotlights").doc(updatedSpotlight.id).set(updatedSpotlight.toJson());
  void cancelSpotlight(Spotlight spotlight) => FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("spotlights").doc(spotlight.id).update({"end_time": Timestamp.now()});

  Future<void> createEvent(Event newEvent) async {

    CollectionReference eventCollection = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events");
    CollectionReference chatsCollection = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats");

    DocumentReference chatRef = chatsCollection.doc();
    DocumentReference eventRef = eventCollection.doc(chatRef.id);

    Map<String, dynamic> newChat = {
      "event": {
        "title" : newEvent.title,
        "location": newEvent.location,
        "start_time": Timestamp.fromDate(newEvent.startTime),
        "end_time": Timestamp.fromDate(newEvent.endTime),
        "ref" : eventRef
      },
      "last_time_message_sent" : null,
      "messages" : [],
      "society" : SocietyAuthentication.instance.societyInfo!.toJson(),
      "users" :{},
      "type" : "event_chat"
    };


    final batch = FirebaseFirestore.instance.batch();
    batch.set(eventRef, newEvent.toJson());
    batch.set(chatRef, newChat);
    await batch.commit();

  }

  Future<void> updateEvent(Event event) async {

    DocumentReference eventRef = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .doc(event.id);
    DocumentReference chatRef = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .doc(event.id);

    Map<String, dynamic> updatedChat = {
      "event": {
        "title" : event.title,
        "location": event.location,
        "start_time": Timestamp.fromDate(event.startTime),
        "end_time": Timestamp.fromDate(event.endTime),
        "ref" : eventRef
      },
    };


    final batch = FirebaseFirestore.instance.batch();
    batch.update(eventRef, event.toJson());
    batch.update(chatRef, updatedChat);
    await batch.commit();
  }

  Future<void> deleteEvent(Event event) async {
    FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("events").doc(event.id).delete();
    FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("chats").doc(event.id).delete();
  }
}

