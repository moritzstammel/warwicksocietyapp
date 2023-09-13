
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class FirestoreUser {
  final String id;
  final String email;
  final String username;
  final List<SocietyInfo> followedSocieties;
  final int points;
  final String imageUrl;
  final String bannerUrl;
  final List<String> eventsSeen;
  final Map<String,bool> tags;

  FirestoreUser({required this.id, required this.email,
    required this.username, required this.followedSocieties,required this.points,required this.imageUrl,required this.bannerUrl,required this.eventsSeen, required this.tags});

  factory FirestoreUser.fromJson(Map<String, dynamic> json,String id) {
    return FirestoreUser(
      id: id,email: json["email"],
      username: json["username"], followedSocieties: json["followed_societies"].map<SocietyInfo>((doc) => SocietyInfo.fromJson(doc)).toList(),points: json["points"],
      imageUrl: json["image_url"], bannerUrl: json["banner_url"], eventsSeen: json["events_seen"].cast<String>(), tags: Map<String, bool>.from(json["tags"])

    );
  }

}
