
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String fullName;
  final bool active;
  final String imageUrl;
  final String username;
  final DocumentReference ref;

  UserInfo({required this.fullName,required this.active, required this.imageUrl,required this.username,required this.ref});

  factory UserInfo.fromJson(Map<String, dynamic> json) {

    return UserInfo(fullName: json["full_name"],username: json["username"], imageUrl: json["image_url"], ref: json["ref"], active: json["active"]);
  }

}
