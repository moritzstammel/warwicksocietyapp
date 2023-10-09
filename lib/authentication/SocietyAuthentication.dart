import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/society_info.dart';

class SocietyAuthentication {
  SocietyInfo? societyInfo;

  SocietyAuthentication._privateConstructor();

  static final SocietyAuthentication _instance = SocietyAuthentication._privateConstructor();

  static SocietyAuthentication get instance => _instance;

  bool get isSociety => societyInfo != null;

  void logOut() => (societyInfo = null);

  Future<void> createSociety(String name,String logoUrl) async {
    CollectionReference societyCollection = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("societies");
    CollectionReference chatsCollection = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats");

    DocumentReference socRef = societyCollection.doc();
    DocumentReference chatRef = chatsCollection.doc();

    Map<String, dynamic> newSociety = {
      "name": name,
      "ref": socRef,
      "logo_url":  logoUrl,
      "admins" : {},
      "chat_ref" : chatRef
    };

    Map<String, dynamic> newChat = {
      "type": "society_chat",
      "event": null,
      "time_of_last_message" : null,
      "messages" : [],
      "society" : {
        "name": name,
        "ref": socRef,
        "logo_url":  logoUrl,
      },
      "users" : {}
    };


    final batch = FirebaseFirestore.instance.batch();
    batch.set(socRef, newSociety);
    batch.set(chatRef,newChat);
    await batch.commit();
  }

  void refresh() async {
    societyInfo = await societyInfo!.ref.get().then((value) => SocietyInfo.fromJson(value.data() as Map<String,dynamic>));
  }
}