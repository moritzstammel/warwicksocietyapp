
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class FirestoreUser {
  final String id;
  final String email;
  final String username;
  final Map<String,SocietyInfo> followedSocieties;
  final int points;
  final String imageUrl;
  final String bannerUrl;
  final Map<String,bool> tags;
  final String fullName;
  final DateTime createdAt;
  final String? fcmToken;

  FirestoreUser({required this.id, required this.email, required this.username, required this.followedSocieties,required this.points,required this.imageUrl,
    required this.bannerUrl, required this.tags,required this.fullName, required this.createdAt,required this.fcmToken});

  factory FirestoreUser.fromJson(Map<String, dynamic> json,String id) {
    return FirestoreUser(
      id: id,email: json["email"],
      username: json["username"], followedSocieties: Map<String, dynamic>.from(json["followed_societies"]).map((key, value) => MapEntry(key, SocietyInfo.fromJson(value))),points: json["points"],
      imageUrl: json["image_url"], bannerUrl: json["banner_url"], tags: Map<String, bool>.from(json["tags"]),fullName: json["full_name"],
      createdAt: json["created_at"].toDate(),fcmToken: json["fcm_token"]

    );
  }
  DocumentReference get ref {
    return FirebaseFirestore.instance.doc("universities/university-of-warwick/users/$id");
  }
}
