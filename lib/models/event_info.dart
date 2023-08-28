import 'package:cloud_firestore/cloud_firestore.dart';

class EventInfo {
  final String title;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final DocumentReference ref;


  EventInfo({required this.title,required this.location,required this.startTime,required this.endTime,required this.ref});

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
        title: json["title"],
        location: json["location"],
        startTime: json["start_time"].toDate(),
        endTime: json["end_time"].toDate(),
        ref: json["ref"]
    );
  }
}