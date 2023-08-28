
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class FirestoreUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final List<SocietyInfo> followedSocieties;
  final int points;
  final String imageUrl;

  FirestoreUser({required this.id, required this.email, required this.firstName,required this.lastName,
    required this.username, required this.followedSocieties,required this.points,required this.imageUrl});

  factory FirestoreUser.fromJson(Map<String, dynamic> json,String id) {
    return FirestoreUser(
      id: id,email: json["email"], firstName: json["first_name"], lastName: json["last_name"],
      username: json["username"],followedSocieties: json["followed_societies"].map<SocietyInfo>((doc) => SocietyInfo.fromJson(doc)).toList(),points: json["points"],
      imageUrl: json["image_url"]

    );
  }

}
