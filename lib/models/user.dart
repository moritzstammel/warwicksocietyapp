
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class FirestoreUser {
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final List<SocietyInfo> followedSocieties;
  final int points;

  FirestoreUser({required this.email, required this.firstName,required this.lastName,
    required this.username, required this.followedSocieties,required this.points,});

  factory FirestoreUser.fromJson(Map<String, dynamic> json) {
    return FirestoreUser(
      email: json["email"], firstName: json["first_name"], lastName: json["last_name"],
      username: json["username"],followedSocieties: json["followed_societies"].map<SocietyInfo>((doc) => SocietyInfo.fromJson(doc)).toList(),points: json["points"]
    );
  }

}
