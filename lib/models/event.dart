
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';
import 'package:warwicksocietyapp/models/user_info.dart';

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
  final Map<String,UserInfo> registeredUsers;
  final String tag;

  Event(
      {required this.id,required this.title, required this.description, required this.location, required this.startTime, required this.endTime,
        required this.points, required this.societyInfo, required this.images, required this.registeredUsers, required this.tag});


  factory Event.fromJson(Map<String, dynamic> json,String id) {
    Map<String,UserInfo> userList =  Map<String, dynamic>.from(json["registered_users"]).map((key, value) => MapEntry(key,UserInfo.fromJson(value)));
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
        registeredUsers: userList,
        tag: json["tag"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "location": location,
      "start_time": Timestamp.fromDate(startTime),
      "end_time": Timestamp.fromDate(endTime),
      "points": points,
      "society": societyInfo.toJson(),
      "images": images,
      "registered_users": registeredUsers,
      "tag": tag
    };
  }

  @override
  String toString() {
    return title;
  }
}