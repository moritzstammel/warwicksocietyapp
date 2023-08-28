
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String name;
  final String imageUrl;
  final DocumentReference ref;

  UserInfo({required this.name, required this.imageUrl,required this.ref});

  factory UserInfo.fromJson(Map<String, dynamic> json) {

    return UserInfo(name: json["name"], imageUrl: json["image_url"], ref: json["ref"]);
  }

}
