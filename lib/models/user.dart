
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final List<SocietyInfo> followedSocieties;
  final int points;

  User({required this.email, required this.firstName,required this.lastName,
    required this.username, required this.followedSocieties,required this.points,});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"], firstName: json["first_name"], lastName: json["last_name"],
      username: json["username"],followedSocieties: json["followed_societies"],points: json["points"]
    );
  }

}
