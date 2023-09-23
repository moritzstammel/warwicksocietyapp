import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  Future<FirestoreUser> getFirestoreUser(DocumentReference userRef) => userRef.get().then((value) => FirestoreUser.fromJson(value.data() as Map<String,dynamic>,value.id));

  Future<void> followSociety(SocietyInfo society,{DocumentReference? initialUserRef}) async {

    FirestoreUser firestoreUser = (initialUserRef== null) ? FirestoreAuthentication.instance.firestoreUser! : await getFirestoreUser(initialUserRef);
    DocumentReference userRef = firestoreUser.ref;

    final batch = FirebaseFirestore.instance.batch();

    batch.update(userRef, {
      "followed_societies.${society.ref.id}" : society.toJson()
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
      "followed_societies.${society.ref.id}" : FieldValue.delete()
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

    Map<String, dynamic> eventJson = {
      "title": newEvent.title,
      "description": newEvent.description,
      "location": newEvent.location,
      "start_time": Timestamp.fromDate(newEvent.startTime),
      "end_time": Timestamp.fromDate(newEvent.endTime),
      "points": newEvent.points,
      "society": newEvent.societyInfo.toJson(),
      "images": newEvent.images,
      "tag": newEvent.tag,
      "registered_users" :{},
    };

    Map<String, dynamic> chatJson = {
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
    batch.set(eventRef, eventJson);
    batch.set(chatRef, chatJson);
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
  Future<DocumentReference> createFirestoreUser(String email) async{
    final CollectionReference userCollection = FirebaseFirestore.instance.collection(
        '/universities/university-of-warwick/users');

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    return await userCollection.add({
      "email": email,
      "followed_societies": {},
      "points": 0,
      "tags":{},
      "username" :_emailToUserName(email),
      "image_url" : "https://firebasestorage.googleapis.com/v0/b/warwick-society-app.appspot.com/o/default_profile_image.png?alt=media",
      "banner_url" : "https://firebasestorage.googleapis.com/v0/b/warwick-society-app.appspot.com/o/default_profile_banner.jpg?alt=media",
      "fcm_token":fcmToken,
      "created_at": Timestamp.now(),
      "full_name" : _emailToFullName(email)
    });
  }
  String _emailToFullName(String email) {
    // Remove the @warwick.ac.uk from the end
    email = email.replaceAll(RegExp(r'@warwick\.ac\.uk$'), '');

    // Replace "." and "-" with a space
    email = email.replaceAll(RegExp(r'[.-]'), ' ');

    // Split the string by spaces, capitalize each word, and join them back
    email = email.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');

    return email;
  }
  String _emailToUserName(String email) {
    // Remove "@warwick.ac.uk" from the end of the email
    if (email.endsWith("@warwick.ac.uk")) {
      email = email.substring(0, email.length - "@warwick.ac.uk".length);
    }

    // Replace all non-alphabetic characters with an empty string
    return email.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

}

