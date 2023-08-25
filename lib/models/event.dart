
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final int points;
  final SocietyInfo societyInfo;
  final List<String> images;
  final List<DocumentReference> registeredUsers;

  Event(
      {required this.id,required this.title, required this.description, required this.location, required this.startTime, required this.endTime,
        required this.points, required this.societyInfo, required this.images, required this.registeredUsers});


  factory Event.fromJson(Map<String, dynamic> json,String id) {



    return Event(
        id:id,
        title: json["title"],
        description: json["description"],
        location: json["location"],
        startTime: json["start_time"].toDate(),
        endTime: json["end_time"].toDate(),
        points: json["points"],
        societyInfo: SocietyInfo.fromJson(json["society"]),
        images: json["images"].cast<String>(),
        registeredUsers: json["registered_users"].cast<DocumentReference>());
  }
}